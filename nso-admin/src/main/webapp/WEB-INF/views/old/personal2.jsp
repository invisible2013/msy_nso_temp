<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="header.jsp" %>
<script>
    $(document).ready(function () {
        $('#birthDate').datepicker({
            dateFormat: 'dd/mm/yy',
            changeMonth: true,
            changeYear: true,
            yearRange: '1950:' + new Date()
        });
    });
    var app = angular.module("app", []);
    app.controller("userCtrl", function ($scope, $http, $filter) {
        $scope.persons = [];
        $scope.person = {};
        $scope.selectedTypeId = 1;
        $scope.selectedFederationId = 0;
        function getUsers(res) {
            $scope.persons = res.data;
            console.log(res.data);
        }

        ajaxCall($http, "event/get-persons-by-type", {typeId: 1}, getUsers);

        function getUsersByGroup(res) {
            $scope.federations = res.data;
        }

        ajaxCall($http, "users/get-users-by-group", {groupId: 4}, getUsersByGroup);

        $scope.searchChange = function () {
            if ($scope.selectedFederationId != 0) {
                ajaxCall($http, "event/get-persons-by-type", {
                    typeId: $scope.selectedTypeId,
                    federationId: $scope.selectedFederationId
                }, getUsers);
            } else {
                ajaxCall($http, "event/get-persons-by-type", {typeId: $scope.selectedTypeId}, getUsers);
            }
        };

        function getTypes(res) {
            $scope.types = res.data;
        }

        ajaxCall($http, "misc/get-person-types", null, getTypes);

        $scope.addUser = function () {
            ajaxCall($http, "event/add-person", angular.toJson($scope.person), reload);
        };
        $scope.editPerson = function (itemId) {
            if (itemId != undefined) {
                var selected = $filter('filter')($scope.persons, {id: itemId}, true);
                $scope.person = selected[0];
            }
        };
        $scope.selectPerson = function () {
            $scope.person = {typeId: $scope.selectedTypeId};
        };
        function isEmptyValue(variable) {
            return variable == undefined || variable == null || variable.length == 0;
        };

        $scope.addPersonItem = function () {
            if (isEmptyValue($scope.person.personalNumber)) {
                Modal.info('შეიყვანეთ მონაწილის პირადი N');
                return;
            }
            if (isEmptyValue($scope.person.firstName)) {
                Modal.info('შეიყვანეთ მონაწილის სახელი');
                return;
            }
            if (isEmptyValue($scope.person.lastName)) {
                Modal.info('შეიყვანეთ მონაწილის გვარი');
                return;
            }
            if (isEmptyValue($scope.person.birthDate)) {
                Modal.info('შეიყვანეთ მონაწილის  დაბადების თარიღი');
                return;
            }
            var file = $('#personDocumentId')[0].files[0];

            function addPersonSuccess(res) {
                console.log(res.data);
                var personId = res.data.id;
                if (file != undefined) {
                    var oMyForm = new FormData();
                    oMyForm.append("personId", personId);
                    oMyForm.append("file", file);
                    $.ajax({
                        url: 'event/add-person-image',
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
                } else {
                    location.reload();
                }
            }

            ajaxCall($http, "event/add-person-item", angular.toJson($scope.person), addPersonSuccess);
        };
        $scope.open = function (name) {
            window.open('file/draw/' + name + '/');
        };

        $scope.removePerson = function () {
            if (confirm("დარწმუნებული ხართ რომ გსურთ წაშლა?")) {
                ajaxCall($http, "event/remove-person-item", angular.toJson($scope.person), addPersonSuccess);
            }
        };
    });
</script>
<div class="col-md-12" ng-controller="userCtrl">

    <div class="modal fade bs-example-modal-md" id="addPersonModal" tabindex="-1" role="dialog"
         aria-labelledby="addIdNumberLabel" aria-hidden="true">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="addIdNumberLabel">პერსონალის ინფორმაცია</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="form-horizontal">
                            <div class="form-group col-sm-12">
                                <label class="control-label col-sm-3">ტიპი</label>
                                <div class="col-sm-9">
                                    <select class="form-control input-sm" ng-model="person.typeId">
                                        <option ng-repeat="t in types" value="{{t.id}}">{{t.name}}</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group col-sm-12 ">
                                <label class="control-label  col-sm-3">სახელი *</label>
                                <div class="col-sm-9">
                                    <input type="text" ng-model="person.firstName" class="form-control input-sm">
                                </div>
                            </div>
                            <div class="form-group col-sm-12 ">
                                <label class="control-label  col-sm-3">გვარი *</label>
                                <div class="col-sm-9">
                                    <input type="text" ng-model="person.lastName" class="form-control input-sm">
                                </div>
                            </div>
                            <div class="form-group col-sm-12 ">
                                <label class="control-label  col-sm-3">პირადი ნომერი *</label>
                                <div class="col-sm-9">
                                    <input type="text" ng-model="person.personalNumber" class="form-control input-sm">
                                </div>
                            </div>
                            <div class="form-group col-sm-12">
                                <label class="control-label col-sm-3">სურათი</label>
                                <div class="col-sm-9">
                                    <input type="file" id="personDocumentId" name="file"
                                           class="form-control input-sm upload-file">
                                </div>
                            </div>
                            <div class="form-group col-sm-12">
                                <label class="control-label col-sm-3">დაბადების თარიღი *</label>
                                <div class="col-sm-9">
                                    <input type="text" id="birthDate" ng-model="person.birthDate"
                                           class="form-control input-sm">
                                </div>
                            </div>
                            <div class="form-group col-sm-12">
                                <label class="control-label  col-sm-3">სახეობა</label>
                                <div class="col-sm-9">
                                    <input type="text" id="category" ng-model="person.category"
                                           class="form-control input-sm">
                                </div>
                            </div>
                            <div class="form-group col-sm-12">
                                <label class="control-label col-sm-3">წონა/კატეგორია</label>
                                <div class="col-sm-9">
                                    <input type="text" ng-model="person.weightCategory"
                                           class="form-control input-sm">
                                </div>
                            </div>
                            <div class="form-group col-sm-12">
                                <label class="control-label col-sm-3">ქალაქი/რაიონი</label>
                                <div class="col-xs-9">
                                    <input type="text" ng-model="person.city" class="form-control input-sm">
                                </div>
                            </div>
                            <div class="form-group col-sm-12">
                                <label class="control-label col-sm-3">კლუბი</label>
                                <div class="col-sm-9">
                                    <input type="text" ng-model="person.club" class="form-control input-sm">
                                </div>
                            </div>
                            <div class="form-group col-sm-12">
                                <label class="control-label col-sm-3">პოზიცია</label>
                                <div class="col-sm-9">
                                    <input type="text" id="position" ng-model="person.position"
                                           class="form-control input-sm">
                                </div>
                            </div>
                            <div class="form-group col-sm-12">
                                <label class="control-label col-sm-3">პირადი მწვრთნელი</label>
                                <div class="col-sm-9">
                                    <input type="text" id="trainer" ng-model="person.trainer"
                                           class="form-control input-sm">
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="addPersonItem()">შენახვა</button>
                </div>
            </div>
        </div>
    </div>


    <br/>
    <div class="row">
        <%if (hasPermissions(request, Groups.ADMIN.getName()) || hasPermissions(request, Groups.MANAGER.getName())) {%>
        <div class="form-group col-sm-2">
            <label class="control-label">ფედერაცია</label>
            <select class="form-control input-sm" ng-model="selectedFederationId" ng-change="searchChange()">
                <option ng-repeat="f in federations" value="{{f.id}}">{{f.name}}</option>
            </select>
        </div>
        <%}%>

        <div class="form-group col-sm-2">
            <label class="control-label">ტიპი</label>
            <select class="form-control input-sm" ng-model="selectedTypeId" ng-change="searchChange()">
                <option ng-repeat="t in types" value="{{t.id}}">{{t.name}}</option>
            </select>
        </div>
        <div class="form-group col-sm-2 text-right" style="float:right;">
            <label class="control-label"></label>
            <%if (hasPermissions(request, Groups.FEDERATION.getName())) {%>
            <button type="button" style="margin-top: 20px;" class="btn btn-primary btn-xs"
                    data-toggle="modal" data-target="#addPersonModal" ng-click="selectPerson()">
                დამატება
            </button>
            <%}%>

        </div>
    </div>
    <table class="table table-striped table-hover" id="userList">
        <tr>
            <th>ID</th>
            <th>სახელი</th>
            <th>საიდ. N</th>
            <th>დაბადების თარიღი</th>
            <th>კლუბი</th>
            <th>ქალაქი</th>
            <th>პოზიცია</th>
            <th>ტრენერი</th>
            <th>სახეობა</th>
            <th>წონა</th>
            <th></th>
        </tr>
        <tr ng-repeat="i in persons">
            <td>{{$index + 1}}</td>
            <td>
                <a class="btn btn-xs" ng-click="open(i.imageUrl);">
                    <img src="file/draw/{{i.optimizedImageUrl}}/" class="img-thumbnail"
                         style="height: 50px; width: 50px;"
                    >
                </a>
                {{i.firstName}} {{i.lastName}}
            </td>
            <td>{{i.personalNumber}}</td>
            <td>{{i.birthDate}}</td>
            <td>{{i.club}}</td>
            <td>{{i.city}}</td>
            <td>{{i.position}}</td>
            <td>{{i.trainer}}</td>
            <td>{{i.category}}</td>
            <td>{{i.weightCategory}}</td>
            <td width="100">
                <%if (hasPermissions(request, Groups.FEDERATION.getName())) {%>
                <button type="button" class="btn btn-xs" data-toggle="modal"
                        data-target="#addPersonModal" ng-click="editPerson(i.id)">
                    <span class="glyphicon glyphicon-pencil"></span>
                </button>
                <button type="button" class="btn btn-xs" ng-click="removePerson(i.id)">
                    <span class="glyphicon glyphicon-remove"></span>
                </button>
                <%}%>

            </td>
        </tr>
    </table>
</div>
<%@include file="footer.jsp" %>
