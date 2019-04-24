<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="old/header.jsp" %>
<script>
    var app = angular.module("app", []);
    app.controller("requestCtrl", function ($scope, $http, $filter, $location) {
        var absUrl = $location.absUrl();
        $scope.currentEventId = absUrl.split("?")[1].split("=")[1];

        function getEventDocumentTypes(res) {
            $scope.documentTypes = res.data;
        }

        ajaxCall($http, "misc/get-document-types", {eventTypeId: 0}, getEventDocumentTypes);
        $scope.documents = [];
        if ($scope.currentEventId > 0) {
            function getEvent(res) {
                $scope.documents = res.data.documents;
                console.log(res.data);
            }

            ajaxCall($http, "event/get-event", angular.toJson({'eventId': $scope.currentEventId}), getEvent);
        }
        $scope.reportDocument = function () {
            Modal.confirm("დარწმუნებული ხართ რომ ყველა დოკუმენტი ატვირთეთ და გსურთ გაგზავნა?", function () {
                function successReportDocument() {
                    window.location = "home";
                }

                ajaxCall($http, "event/report-event", angular.toJson({'eventId': $scope.currentEventId}), successReportDocument);
            })
        };
        $scope.tpFilter = function (item) {
            return (item.id == 5 || item.id == 7);
        };
        $scope.typeFilter = function (item) {
            return (item.type.id == 5 || item.type.id == 7);
        };
        $scope.deleteEventDocument = function (id) {
            Modal.confirm("დარწმუნებული ხართ რომ გსურთ წაშლა?", function () {
                if (id != undefined) {
                    ajaxCall($http, "event/delete-event-document", angular.toJson({'documentId': id}), reload);
                }
            })
        };
        $scope.addDocument = function () {
            var oMyForm = new FormData();
            oMyForm.append("eventId", $scope.currentEventId);
            oMyForm.append("typeId", $scope.document.typeId);
            oMyForm.append("file", $('#documentId')[0].files[0]);
            $.ajax({
                url: 'event/add-document',
                data: oMyForm,
                dataType: 'text',
                processData: false,
                contentType: false,
                type: 'POST',
                success: function (data) {
                    location.reload();
                }
            }).success(function (data) {
                location.reload();
            }).error(function (data, status, headers, config) {
                location.reload();
            });
        };
    });
</script>
<div class="col-md-12" ng-controller="requestCtrl">
    <br/>
    <form class="form-horizontal" id="documentForm">
        <div class="form-group col-sm-8">
            <label class="control-label col-sm-3">დოკუმენტის ტიპი</label>
            <div class="col-sm-9">
                <select class="form-control input-sm" ng-model="document.typeId">
                    <option ng-repeat="dt in documentTypes| filter: tpFilter" value="{{dt.id}}">{{dt.name}}</option>
                </select>
            </div>
        </div>
        <div class="form-group col-sm-8">
            <label class="control-label col-sm-3">დოკუმენტი</label>
            <div class="col-sm-9">
                <input type="file" id="documentId" name="file" class="form-control input-sm upload-file">
                <input type="hidden" name="typeId" value="{{document.typeId}}">
            </div>
        </div>
        <div class="form-group col-sm-8 text-right">
            <div class="col-sm-12">
                <!--<button type="submit" class="btn btn-primary btn-xs" >დამატება</button>-->
                <button type="button" class="btn btn-primary btn-xs" ng-click="addDocument()">დამატება</button>
            </div>
        </div>
    </form>
    <div class="col-sm-8">
        <table class="table table-striped table-hover">
            <tr>
                <th>ID</th>
                <th>ტიპი</th>
                <th>ფაილი</th>
                <th></th>
            </tr>
            <tr ng-repeat="d in documents| filter: typeFilter">
                <td>{{$index + 1}}</td>
                <td>{{ d.type.name}}</td>
                <td>{{ d.name}}</td>
                <td>
                    <button type="button" class="btn btn-xs" ng-click="deleteEventDocument(d.id);">
                        <span class="glyphicon glyphicon-remove"></span>
                    </button>
                </td>
            </tr>
        </table>
        <div class="form-group text-right">
            <div class="col-sm-12">
                <button type="button" class="btn btn-primary btn-xs" ng-click="reportDocument()">ანგარიშის გაგზავნა
                </button>
            </div>
        </div>
    </div>
</div>
<p></p>
<p></p>
<p></p>
<p></p>
<p></p>
<p></p>
<%@include file="old/footer.jsp" %>
