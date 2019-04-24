
function getLocationById(id) {
    var x = $("#" + id).offset().left;
    var y = $("#" + id).offset().top;
    return {x: x, y: y};
}

function hideById(id) {
    $("#" + id).css("visibility", "hidden");
}

function disableById(id) {
    $("#" + id).prop('disabled', true);
}
function enableById(id) {
    $("#" + id).prop('disabled', false);
}

function showById(id) {
    $("#" + id).css("visibility", "");
}

function setValue(id, value) {
    $("#" + id).val(value);
}
function getValue(id) {
    return $("#" + id).val();
}

function setText(id, value) {
    $("#" + id).text(value);
}
function getText(id) {
    return $("#" + id).text();
}

function redirect(url) {
    location.href = "" + url;
}

function getObject(id) {
    return $("#" + id);
}
function getObjectByClass(klass) {
    return $("." + klass);
}

function getHashValue(key) {
    if (location.hash != undefined && location.hash.length > 1) {
        return location.hash.match(new RegExp(key + '=([^&]*)'))[1];
    }
    return undefined;
}

function hideByClass(klass) {
    $("." + klass).css("visibility", "hidden");
}

function showByClass(klass) {
    $("." + klass).css('visibility', "");
}

function removeByClass(klass) {
    $("." + klass).remove();
}

function check(id, enable) {
    $("#" + id).prop('checked', enable);
}
function isChecked(id) {
    return getObject(id).is(':checked');
}
function isEmpty(o) {
    return o == null || o == undefined || o.length < 1;
}

function isNull(o) {
    return o == null || o == undefined;
}

function disableByClass(klass) {
    $("." + klass).prop('disabled', true);
}

function enableByClass(klass) {
    $("." + klass).prop('disabled', false);
}

function getrRndomString()
{
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for (var i = 0; i < 10; i++)
        text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
}

function parseJSON(json) {
    var st;
    try {
        st = JSON.parse(json);
    } catch (err) {
        st = null;
    }
    return st;
}

function getNonZeroAndNegativeRandomNumber() {
    var random = Math.floor(Math.random() * 1000000000);
    if (random == 0)
        return getNonZeroRandomNumber();
    return random > 0 ? -random : random;
}

function $_GET(name){
    var str = window.location.search;
    var objURL = {};

    str.replace(
        new RegExp( "([^?=&]+)(=([^&]*))?", "g" ),
        function( $0, $1, $2, $3 ){
            objURL[ $1 ] = $3;
        }
    );
    return objURL[name];
}