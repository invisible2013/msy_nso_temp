var DATE_FORMAT = "dd/mm/yy";

function getNextDay() {

    var today = new Date();
    var d = today.getDate();
    var m = today.getMonth();
    var y = today.getFullYear();

    var nextDay = new Date(y, m, d + 1);
    return nextDay;
}

function addDateDays(date, dayNumber) {
    var arraydates = date.split("/");
    var newdate = arraydates[1] + "/" + arraydates[0] + "/" + arraydates[2];
    var select = new Date(newdate);
    var d = select.getDate();
    var m = select.getMonth();
    var y = select.getFullYear();

    var nextDay = new Date(y, m, d + dayNumber);
    var month = parseInt(nextDay.getMonth() + 1);
    var day = nextDay.getDate();
    var nextDayString = (day > 9 ? day : '0' + day) + "/" + (month > 9 ? month : '0' + month) + "/" + nextDay.getFullYear();
    return nextDayString;
}

function getCurrentDay() {
    var d = new Date();
    d.setHours(0, 0, 0, 0);
    return d;
}
function getDateById(id) {
    if ($('#' + id).val() != "") {
        var arraydates = $('#' + id).val().split("/");
        var newdate = arraydates[2] + "/" + arraydates[0] + "/" + arraydates[1];
        return new Date(newdate);
    }
}
function getDateStringById(id) {
    if ($('#' + id).val() != "") {
        var arraydates = $('#' + id).val().split("/");
        var newdate = arraydates[1] + "/" + arraydates[0] + "/" + arraydates[2];
        return newdate;
    }
}

function getFormattedDate(date) {
    var stringDate = "";
    if (date) {
        var cur = new Date(date);
        var day = cur.getDate() < 10 ? "0" + cur.getDate() : cur.getDate();
        var month = cur.getMonth() < 10 ? "0" + parseInt(cur.getMonth() + 1) : parseInt(cur.getMonth() + 1);
        stringDate = day + "/" + month + "/" + cur.getFullYear();
    }
    return stringDate;
}


function isEmpty(id) {
    if ($('#' + id).val() != "")
        return false;
    else
        return true;
}