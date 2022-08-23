let data = null;
window.onload = function () {
    const generate_btn = document.querySelector('.input_div button');
    // click generate button to get value.
    generate_btn.onclick = function () {
        if (!data) {
            // read file
            readFile('data.json');
        } else {
            generateLink(data);
        }
    }
}

// 同文件夹下的json文件路径
function readFile(url) {
    // 申明一个XMLHttpRequest
    const request = new XMLHttpRequest();
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

function generateLink(data) {
    if (data.length <= 0) {
        window.alert('数据已全部加载！');
        return;
    }
    const index = Number.parseInt(data.length * Math.random());
    const website = 'https://' + document.querySelector('.input_div input').value + '/watch?v=' + String(data[index].ser);
    
    // check value
    let isValid = false;
    isValid = true;
    
    if (isValid) {
        // generate li label
        const newLiLabel = document.createElement('li');
        newLiLabel.innerHTML = '<a href="' + String(website) + '" target="_blank">' + String(data[index].name) + '</a>';
        document.querySelector('#video_list').appendChild(newLiLabel);
    }
    data.splice(index, 1);
}
