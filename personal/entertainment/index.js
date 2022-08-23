let data = null;
window.onload = function () {
    document.querySelector('.input_div button').onclick = generate;

    const website_input = document.querySelector('.input_div input');
    website_input.addEventListener('keydown', (event) => {
        if (event.code == 'Enter') {
            generate();
        }
    })
    website_input.addEventListener('focus', (event) => {
        // hint website
    })
    
    document.addEventListener('keydown', (event) => {
        // console.log(event.code);
        const letterPattern = /^(Key[A-Z])|(Minus)|(Period)|(Digit[0-9])$/;
        if (letterPattern.test(event.code)) {
            website_input.focus();;
        }
    })
}

// 同文件夹下的json文件路径
function readFile(url) {
    // 申明一个XMLHttpRequest
    const request = getXmlHttpRequest();
    // 设置请求方法与路径
    request.open("get", url);
    // 不发送数据到服务器
    request.send(null);
    // XHR对象获取到返回信息后执行
    request.onload = function () {
        // 返回状态为200，即为数据获取成功
        if (request.status == 200) {
            data = JSON.parse(request.responseText);
            generateLink(data);
        }
    }
}

function generate() {
    if (!data) {
        // read file
        readFile('data.json');
    } else {
        generateLink(data);
    }
}

function generateLink(data) {
    if (data.length <= 0) {
        window.alert('数据已全部加载！');
        return;
    }
    const index = Number.parseInt(data.length * Math.random());
    const domain = document.querySelector('.input_div input');
    const website = 'https://' + domain.value + '/watch?v=' + String(data[index].ser);
    
    const domainPattern = /^[a-zA-Z0-9\-]+(\.[a-zA-Z0-9\-]*)+$/;

    // check whether url valid
    if (!domainPattern.test(domain.value) || !isURLValid(website)) {
        window.alert('The URL is invalid');
        domain.value = '';
        return;
    }

    // generate li label
    const newLiLabel = document.createElement('li');
    newLiLabel.innerHTML = '<a href="' + String(website) + '" target="_blank">' + String(data[index].name) + '</a>';
    document.querySelector('#video_list').appendChild(newLiLabel);
    data.splice(index, 1);
}

function isURLValid(url) {
    return true;
    const xmlhttp = getXmlHttpRequest();
    // 第三个参数表示是否异步
    xmlhttp.open("GET", url, false); 
    xmlhttp.send();
    if (xmlhttp.readyState == 4) {
        if (xmlhttp.status == 200) {
            return true;
        } else {
            return false;
        }
    }
}

function getXmlHttpRequest() {
    if (window.XMLHttpRequest) {
        return new XMLHttpRequest();
    } else if (window.ActiveXObject) {
        return new ActiveXObject("Microsoft.XMLHTTP");
    }
};