<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="old/header.jsp" %>
<script>
    var app = angular.module("app", []);
    app.controller("requestCtrl", function ($scope, $http, $filter, $location) {
        var absUrl = $location.absUrl();
        $scope.currentEventId = absUrl.split("?")[1].split("=")[1];
        $scope.persons = [];
        $scope.categories = [];
        $scope.personTypes = [];
        $scope.person = {'eventId': $scope.currentEventId, 'category': 1, 'type': 1};
        if ($scope.currentEventId > 0) {
            function getEvent(res) {
                $scope.persons = res.data.persons;
                console.log(res.data);
            }

            ajaxCall($http, "event/get-event", {eventId: $scope.currentEventId}, getEvent);
        }
        function getEventCategories(res) {
            $scope.categories = res.data;
        }

        ajaxCall($http, "misc/get-event-categories", null, getEventCategories);
        function getPersonTypes(res) {
            $scope.personTypes = res.data;
        }

        ajaxCall($http, "misc/get-person-types", null, getPersonTypes);

        $scope.addPersonItem = function () {
            ajaxCall($http, "event/add-person", angular.toJson($scope.person), reload);
        };
        $scope.editPersonItem = function (id, index) {
            if (id != undefined) {
                var selected = $filter('filter')($scope.persons, {id: id});
                $scope.person = selected[0];
            } else {
                $scope.person = $scope.persons[index];
            }
        };
        $scope.getCategory = function (id) {
            return $filter('filter')($scope.types, {id: id}, true)[0].name;
        };
        $scope.deletePersonItem = function (id, index) {
            Modal.confirm("დარწმუნებული ხართ რომ გსურთ წაშლა?", function () {
                if (id != undefined) {
                    var selected = $filter('filter')($scope.persons, {id: id}, true);
                    $scope.selected = selected[0];
                } else {
                    $scope.selected = $scope.persons[index];
                }
                $scope.persons.splice($scope.persons.indexOf($scope.selected), 1);
            })
        };
    });
</script>
<div class="col-md-12" ng-controller="requestCtrl">
    <br/>
    <form class="form-horizontal">
        <div class="form-group col-sm-8">
            <label class="control-label col-sm-3">მონაწილე</label>
            <div class="col-sm-9">
                <select class="form-control input-sm" ng-model="person.type">
                    <option ng-repeat="t in personTypes" value="{{t.id}}">{{t.name}}</option>
                </select>
            </div>
        </div>
        <div class="form-group col-sm-8 ">
            <label class="control-label  col-sm-3">სახელი</label>
            <div class="col-sm-9">
                <input type="text" ng-model="person.firstName" class="form-control input-sm">
            </div>
        </div>
        <div class="form-group col-sm-8 ">
            <label class="control-label  col-sm-3">გვარი</label>
            <div class="col-sm-9">
                <input type="text" ng-model="person.lastName" class="form-control input-sm">
            </div>
        </div>
        <div class="form-group col-sm-8">
            <label class="control-label  col-sm-3">პირადი N</label>
            <div class="col-sm-7">
                <input type="text" ng-model="person.personalNumber" class="form-control input-sm">
            </div>
            <div class="col-sm-2 text-right">
                <input id="searchItemBtn" type="button" class="btn btn-primary btn-xs" value="ძიება"
                       ng-click="searchPerson()">
            </div>
        </div>

        <div class="col-md-1"></div>

        <div class="form-group col-sm-8">
            <label class="control-label  col-sm-3">სახეობა</label>
            <div class="col-sm-9">
                <select class="form-control input-sm" ng-model="person.category">
                    <option ng-repeat="is in categories" value="{{is.id}}">{{is.name}}</option>
                </select>
            </div>
        </div>
        <div class="form-group col-sm-8 ">
            <label class="control-label col-sm-3">წონა/კატეგორია</label>
            <div class="col-sm-9">
                <input type="text" id="" ng-model="person.weightCategory" class="form-control input-sm">
            </div>
        </div>
        <div class="form-group col-sm-8">
            <label class="control-label col-sm-3">ქალაქი/რაიონი</label>
            <div class="col-xs-9">
                <input type="text" id="" ng-model="person.city" class="form-control input-sm">
            </div>
        </div>
        <div class="form-group col-sm-8">
            <label class="control-label col-sm-3">კლუბი</label>
            <div class="col-sm-9">
                <input type="text" id="" ng-model="person.club" class="form-control input-sm">
            </div>
        </div>
        <div class="form-group col-sm-8">
            <label class="control-label col-sm-3">პოზიცია</label>
            <div class="col-sm-9">
                <input type="text" id="" ng-model="person.position" class="form-control input-sm">
            </div>
        </div>
        <div class="form-group col-sm-8">
            <label class="control-label col-sm-3">პირადი მწვრთნელი</label>
            <div class="col-sm-9">
                <input type="text" id="" ng-model="person.trainer" class="form-control input-sm">
            </div>
        </div>
        <div class="form-group col-sm-8 text-right">
            <div class="col-sm-12">
                <input id="addPersonItemBtn" type="button" class="btn btn-primary btn-xs" value="დამატება"
                       ng-click="addPersonItem()">
            </div>
        </div>

    </form>
    <div class="col-md-11">
        <table class="table table-striped table-hover">
            <tr>
                <th>მონაწილე</th>
                <th>პირ. N</th>
                <th>დ/წ</th>
                <th>კლუბი</th>
                <th>პოზიცია</th>
                <th>წ/კ</th>
                <th></th>
            </tr>
            <tr ng-repeat="x in persons">
                <td>{{ x.firstName}} {{ x.lastName}} ( {{getCategory(x.type)}} )</td>
                <td>{{ x.personalNumber}}</td>
                <td>{{ x.birthDate| date:'dd/MM/yyyy'}}</td>
                <td>{{ x.club}}</td>
                <td>{{ x.position}}</td>
                <td>{{ x.weightCategory}}</td>
                <td>
                    <button type="button" class="btn btn-xs" ng-click="editPersonItem(x.id, $index);">
                        <span class="glyphicon glyphicon-pencil"></span>
                    </button>
                    <button type="button" class="btn btn-xs" ng-click="deletePersonItem(x.id, $index);">
                        <span class="glyphicon glyphicon-remove"></span>
                    </button>
                </td>
            </tr>
        </table>
    </div>

</div>
<p></p>
<p></p>
<p></p>
<p></p>
<p></p>
<p></p>
<%@include file="old/footer.jsp" %>
