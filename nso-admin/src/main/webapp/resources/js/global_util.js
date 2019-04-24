function ajaxCall(http, url, data, successCallback, errorCallback, loadingArea) {

    if (loadingArea) {
        $("#" + loadingArea).addClass('loading-mask');
    }
    http(
        {
            method: "POST",
            url: url,
            contentType: "application/json; charset=utf-8",
            data: data
        }).success(function (data, status, headers, config) {
        if (loadingArea) $("#" + loadingArea).removeClass('loading-mask');
        if (data.errorCode && data.errorCode >= 700) {
            Modal.info(data.errorCode + ": " + data.message);
        } else {
            successCallback(data);
        }
    }).error(function (data, status, headers, config) {
        if (loadingArea) $("#" + loadingArea).removeClass('loading-mask');
        if (status == 701) {
            window.location = data;
        }
        if (errorCallback) {
            errorCallback(data);
        } else {
            Modal.info({
                body: data, yes: "OK", yesClass: 'btn-danger',
                callback: function (resp) {
                    Modal.hide();
                }
            })
        }
    });
}
function ajaxCallNotJsonContentType(http, url, data, sucessCallback, errorCallback) {
    http(
        {
            type: 'POST',
            url: url,
            dataType: 'text',
            processData: false,
            contentType: false,
            data: data
        }).success(function (data, status, headers, config) {
        sucessCallback(data);
    }).error(function (data, status, headers, config) {
        if (errorCallback)
            errorCallback(data);
        else {
            Modal.info(data.resposeText);
        }
    });
}
