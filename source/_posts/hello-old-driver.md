---
layout: post
title: hello-old-driver
date: 2021/10/7
updated: 2021/10/7
cover: /assets/github.webp
# coverWidth: 920
# coverHeight: 613
comments: true
categories: 
- 技术
tags:
- GitHub
---


[GitHub链接](https://github.com/Chion82/hello-old-driver)

下面主要分析三个文件，分别为：
- `magnet_crawler.py`
- `sync.sh`
- `weibo_poster.sh`


`magnet_crawler.py`

```python
import requests, re, json, sys, os

reload(sys)
sys.setdefaultencoding('utf8')

cookie = ''
max_depth = 40
viewed_urls = []
found_magnets = []
ignore_url_param = True
ignore_html_label = True

session = requests.Session()
session.headers.update({'Cookie': cookie})

resource_list = []

# 加载resource_list.json文件，初始化resource_list和found_magnets
if os.path.exists('resource_list.json'):
	with open('resource_list.json', 'r') as json_file:
		resource_list = json.loads(json_file.read())
	for resource in resource_list:
		found_magnets.extend(resource['magnets'])


def scan_page(url, depth=0):
	# 设置递归终止条件
	if url in viewed_urls:
		return
	if (depth > max_depth):
		return

	print('Entering: ' + url)
	sys.stdout.flush()

	try:
		result = session.get(url, timeout=60)
		if not (result.status_code >= 400 and result.status_code<500):
			# 如果status_code不为200，则会抛出异常
			result.raise_for_status()
		viewed_urls.append(url)
	except Exception:
		# 有异常就再次访问，其实这里如果depth+1会更好
		scan_page(url, depth)
		return
	result_text = result.content
	magnet_list = get_magnet_links(result_text)
	sub_urls = get_sub_urls(result_text, url)
	page_title = get_page_title(result_text)
	new_resource = {'title':page_title, 'magnets': magnet_list}

	# 如果新资源已经在资源列表里了，就直接访问该url的子url
	if new_resource in resource_list:
		for sub_url in sub_urls:
			scan_page(sub_url, depth+1)
		return

	# 如果磁力链条数大于0，则对该资源进行处理
	if (len(magnet_list) > 0):
		# 将标题和磁力链写入文件（magnet_output）
		# 将磁力链也输出到文件（lastsync.log）
		append_title_to_file(page_title, 'magnet_output')
		for magnet in magnet_list:
			print('Found magnet: ' + magnet)
			sys.stdout.flush()
			append_magnet_to_file(magnet, 'magnet_output')
		# 将该资源添加到资源列表
		resource_list.append(new_resource)
		"""
		下面两句明显影响了效率,首先是去重完全不需要从头去(正好没有多线程),存入文件完全可以遇到异常时再存取,而不是拿到一条存一条
		"""
		# 删除重复资源
		remove_duplicated_resources()
		# 存入文件
		save_json_to_file('resource_list.json')

	for sub_url in sub_urls:
		scan_page(sub_url, depth+1)

def get_sub_urls(result_text, url):
	# 找到所有超链接,匹配引号的方式很nice
	urls = set(re.findall(r'<a.*?href=[\'"](.*?)[\'"].*?>', result_text))
	sub_urls = []
	for sub_url in urls:
		sub_url = sub_url.strip()
		if sub_url == '':
			continue
		if 'javascript:' in sub_url or 'mailto:' in sub_url:
			continue
		if sub_url[0:4] == 'http':
			try:
				# 保证域名一致
				if (get_url_prefix(sub_url)[1] != get_url_prefix(url)[1]):
					continue
			except Exception:
				continue
		elif sub_url[0:1] == '/':
			sub_url = get_url_prefix(url)[0] + '://' + get_url_prefix(url)[1] + sub_url
		else:
			sub_url = url + '/' + sub_url
		# 将url#号后面的字符去除
		sub_url = re.sub(r'#.*$', '', sub_url)
		sub_url = re.sub(r'//$', '/', sub_url)
		if ignore_url_param:
			# 忽略url的参数
			sub_url = re.sub(r'\?.*$', '', sub_url)
		# 保证子url没有被访问过
		if not sub_url in viewed_urls:
			sub_urls.append(sub_url)
	return sub_urls

def get_url_prefix(url):
	# 得到url的协议和域名
	domain_match = re.search(r'(.*?)://(.*?)/', url)
	if (domain_match):
		return (domain_match.group(1) ,domain_match.group(2))
	else:
		domain_match = re.search(r'(.*?)://(.*)$', url)
		return (domain_match.group(1) ,domain_match.group(2))
	

def get_magnet_links(result_text):
	if (ignore_html_label):
		# 去除标签
		result_text = re.sub(r'<[\s\S]*?>', '', result_text)

	result_text = re.sub(r'([^0-9a-zA-Z])([0-9a-zA-Z]{5,30})[^0-9a-zA-Z]{5,30}([0-9a-zA-Z]{5,30})([^0-9a-zA-Z])', r'\1\2\3\4', result_text)

	hashes = list(set(re.findall(r'[^0-9a-fA-F]([0-9a-fA-F]{40})[^0-9a-fA-F]', result_text)))
	hashes.extend(list(set(re.findall(r'[^0-9a-zA-Z]([0-9a-zA-Z]{32})[^0-9a-zA-Z]', result_text))))
	magnets = list(set([('magnet:?xt=urn:btih:' + hash_value).lower() for hash_value in hashes if not ('magnet:?xt=urn:btih:' + hash_value).lower() in found_magnets]))
	
	found_magnets.extend(magnets)
	return magnets

def get_page_title(result_text):
	match = re.search(r'<title>(.+?)</title>', result_text)
	if match:
		return match.group(1).strip()
	else:
		return ''

def append_magnet_to_file(magnet, filename):
	with open(filename, 'a+') as output_file:
		output_file.write(magnet + '\n')

def append_title_to_file(title, filename):
	with open(filename, 'a+') as output_file:
		output_file.write(title + '\n')

def remove_duplicated_resources():
	"""
	如果有重复,以后头的资源信息为准
	"""
	global resource_list
	new_resource_list = []
	for resource in resource_list:
		add_flag = True
		for added_resource in new_resource_list:
			if added_resource['title'] == resource['title']:
				add_flag = False
				added_resource['magnets'].extend(resource['magnets'])
				added_resource['magnets'] = list(set(added_resource['magnets']))
				break
		if add_flag:
			new_resource_list.append(resource)
	resource_list = new_resource_list

def save_json_to_file(filename):
	with open(filename, 'w+') as output_file:
		# 将json数据转换为字符串写入文件
		output_file.write(json.dumps(resource_list, indent=4, sort_keys=True, ensure_ascii=False))

def main():
	print('Enter a website url to start.')
	# 一般情况下root_url="http://www.liuli.pw"
	root_url = raw_input()
	# 没有协议就加上http协议
	if not '://' in root_url:
		root_url = 'http://' + root_url
	#with open('magnet_output', 'w+') as output_file:
	#	output_file.write('')
	scan_page(root_url)

if __name__ == '__main__':
	main()
```


`sync.sh`

```shell
#!/bin/sh

website_url='http://www.liuli.pw'
# 程序第一次执行的时间的long long形式
first_run_time=1455976198

# 连续访问十次都不成功则视为网站挂了
for i in {1..10}
do
	# curl是一个访问url的命令，-I==-- head代表拿取响应的头部内容
	# grep是一个查找命令
	# wc -l用于统计结果行数
	test_result=$(curl $website_url -I | grep '200 OK' | wc -l)
	# 结果中如果有一行200ok则网站没挂
	if [ $test_result -eq 1 ]; then
		website_test_passed=1
		gua_le_ma='没有'
		break
	else
		website_test_passed=0
		gua_le_ma='卧槽...挂了'
	fi
done

# 测试archives文件夹是否存在,若不存在就创建archives文件夹
test -d 'archives' || mkdir 'archives'

# 复制结果文件到文件夹中归档
cp magnet_output ./archives/magnet_output-$(date +"%F-%H%M%S")
cp resource_list.json ./archives/resource_list.json-$(date +"%F-%H%M%S")

# 效果同上
test -d 'log' || mkdir 'log'
cp lastsync.log ./log/sync.log-$(date +"%F-%H%M%S")

# 如果错误日志文件有内容,则归档
if [ $(cat lasterror.log | wc -l) -gt 0 ];then
	cp lasterror.log ./log/error.log-$(date +"%F-%H%M%S")
fi


if [ $website_test_passed -eq 1 ]; then
	# 在网站没挂的情况下,爬取网站,程序的输出将会保存在lastsync.log
	echo -e "${website_url}\n" | python magnet_crawler.py > lastsync.log 2> lasterror.log
	# 爬虫程序发生错误
	if [ $(cat lasterror.log | wc -l) -gt 0 ]; then
		sync_success=0
	else
		sync_success=1
	fi
else
	sync_success=0
fi

if [ $sync_success -eq 1 ]; then
	# 当次爬取磁力链条数减去上一次磁力链总数等于新增磁力链数量
	added_magnets=$(expr $(cat magnet_output | grep "magnet:?" | wc -l) - $(cat last_magnet_numbers.txt))
	echo $(date) > last_sync_success.txt
	echo $(cat magnet_output | grep "magnet:?" | wc -l) > last_magnet_numbers.txt
	# 将这次同步的结果加上以往的结果一同写入文件
	echo -e "[$(date)] 同步成功 新增记录${added_magnets}条  \n$(cat synclog.txt)" > synclog.txt
else
	echo -e "[$(date)] 同步失败  \n$(cat synclog.txt)" > synclog.txt
fi

# 动态生成README.md文件
cp readme_header.md README.md
echo '今天琉璃神社挂了吗？ '$gua_le_ma'  ' >> README.md
echo '最后同步成功时间:  '$(cat last_sync_success.txt)'  ' >> README.md
echo '已抓取磁力链: '$(cat magnet_output | grep "magnet:?" | wc -l)'  ' >> README.md
echo '本repo已存活: '$(expr $(expr $(date +"%s") - $first_run_time) / 60 / 60 / 24)'天  ' >> README.md

echo -e '\nLog' >> README.md
echo '----' >> README.md
cat synclog.txt >> README.md

# 更新到GitHub
git add .
git commit -m "Sync on $(date)"
git push origin master -f
```


`weibo_poster.sh`

```shell
#/bin/sh

weibo_text='早上好(｀・ω・´)” 今天琉璃神社挂了吗？'

if [ $(cat README.md | grep '今天琉璃神社挂了吗？ 没有' | wc -l) -gt 0 ]; then
	weibo_text="${weibo_text}没有。"
	gualema=0
else
	weibo_text="${weibo_text}卧槽？挂了。。。"
	gualema=1
fi

if [ $(cat lasterror.log | wc -l) -eq 0 ] && [ $gualema -eq 0 ]; then
	magnets_added=$(cat README.md | grep '同步成功 新增记录.*条' | head -n 1 | sed -e 's/\[.*\]//g' | sed -e 's/[^0-9]//g')
	weibo_text="${weibo_text}昨晚同步成功了(●´∀｀●) 新增${magnets_added}条磁力记录"
	titles_added=''
	back_commits=1
	while [ "$titles_added" == "" ]; do
		titles_added=$(git diff HEAD~${back_commits} HEAD resource_list.json | grep '+.*"title":' | sed -e 's/+.*"title": "//g' | sed -e 's/| 琉璃神社 ★ HACG"//g' | sed -e 's/ *$//g' | perl -pe 's/\n/, /g' | sed -e 's/, $//g')
		back_commits=$(($back_commits + 1))
	done
	weibo_text="${weibo_text} 最新资源：${titles_added}"
else
	weibo_text="${weibo_text}昨晚同步出错了哦(,,#ﾟДﾟ) 主人快来调♂教♂我 @炒鸡小学僧 DEBUG_INFO: $(cat lasterror.log)"
fi

# cut命令将文件按列划分，应该是将内容格式化
weibo_text=$(echo $weibo_text | cut -c 1-138)
if [ ${#weibo_text} -eq 138 ]; then
	weibo_text="${weibo_text}..."
fi

echo $weibo_text

access_token=$(cat access_token)

# 用微博接收消息
curl 'https://api.weibo.com/2/statuses/update.json' --data-urlencode "access_token=${access_token}" --data-urlencode "status=${weibo_text}"
```

> 最后一个分析的挺失败的（菜鸡￣□￣｜｜），不过功能却实现了我的一个想法。
> 脚本自动运行，得到新结果或出现错误时会提醒本人。
> 这里大佬用的是微博。

