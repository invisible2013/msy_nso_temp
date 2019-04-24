<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="header.jsp" %>
<script>
    var app = angular.module("app", []);
    app.controller("userCtrl", function ($scope, $http, $filter) {
        $scope.user = {'userGroupId': 1, 'userStatusId': 1};
        $scope.users = [];
        $scope.years = [];
        $scope.userBudgets = [];
        $scope.budget = {};

        function getUsers(res) {
            $scope.users = res.data;
            console.log(res.data);
        }

        ajaxCall($http, "users/get-users", {}, getUsers);

        function getUserGroups(res) {
            $scope.userGroups = res.data;
        }

        ajaxCall($http, "users/get-user-groups", {}, getUserGroups);

        function getUserStatus(res) {
            $scope.userStatuses = res.data;
        }

        ajaxCall($http, "users/get-user-statuses", {}, getUserStatus);

        $scope.addUser = function () {
            ajaxCall($http, "users/add-user", angular.toJson($scope.user), reload);
        };
        $scope.editUser = function (userId) {
            if (userId != undefined) {
                var selected = $filter('filter')($scope.users, {id: userId}, true);
                $scope.user = selected[0];
                $scope.user.userGroupId = $scope.user.usersGroup.id;
                $scope.user.userStatusId = $scope.user.usersStatus.id;
            }
        };
        $scope.selectUser = function () {
            $scope.user = {'userGroupId': 1, 'userStatusId': 1};
        };
        $scope.deleteUser = function (userId) {
            Modal.confirm("დაადასტურეთ ოპერაცია", function () {
                ajaxCall($http, "user/delete-user", angular.toJson($scope.user), reload);
            })
        };
        $scope.addUserBudget = function () {
            ajaxCall($http, "users/add-user-budget", angular.toJson($scope.budget), reload);
        };
        $scope.deleteUserBudget = function (userId) {
            Modal.confirm("დაადასტურეთ ოპერაცია", function () {
                ajaxCall($http, "user/delete-user-budget", {userId: userId}, reload);
            })
        };
        $scope.getUserBudget = function (itemId) {
            function getBudget(res) {
                $scope.userBudgets = res.data;
                console.log(res.data);
                $scope.budget = {userId: itemId};
            }

            ajaxCall($http, "users/get-user-budget", {userId: itemId}, getBudget);
        };
    });
</script>
<div class="col-md-12" ng-controller="userCtrl">
    <br/>
    <div class="modal fade bs-example-modal-md" id="addPersonModal" tabindex="-1" role="dialog"
         aria-labelledby="addIdNumberLabel" aria-hidden="true">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="addIdNumberLabel">მომხმარებლის შესახებ</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="form-horizontal">
                            <div class="form-group col-sm-12">
                                <label class="control-label  col-sm-3">სახელი</label>
                                <div class="col-sm-9">
                                    <input type="text" ng-model="user.name" class="form-control input-sm">
                                </div>
                            </div>
                            <div class="form-group col-sm-12">
                                <label class="control-label  col-sm-3">საიდენთიფიკაციო N</label>
                                <div class="col-sm-9">
                                    <input type="text" ng-model="user.idNumber" class="form-control input-sm">
                                </div>
                            </div>
                            <div class="form-group col-sm-12">
                                <label class="control-label col-sm-3">ელ.ფოსტა</label>
                                <div class="col-sm-9">
                                    <input type="text" id="email" ng-model="user.email" class="form-control input-sm">
                                </div>
                            </div>
                            <div class="form-group col-sm-12">
                                <label class="control-label col-sm-3">პაროლი</label>
                                <div class="col-sm-9">
                                    <input type="password" id="pass" ng-model="user.password"
                                           class="form-control input-sm">
                                </div>
                            </div>
                            <div class="form-group col-sm-12">
                                <label class="control-label col-sm-3">ტელეფონი</label>
                                <div class="col-xs-9">
                                    <input type="text" id="phone" ng-model="user.phone" class="form-control input-sm">
                                </div>
                            </div>
                            <div class="form-group col-sm-12">
                                <label class="control-label col-sm-3">მისამართი</label>
                                <div class="col-sm-9">
                                    <input type="text" id="address" ng-model="user.address"
                                           class="form-control input-sm">
                                </div>
                            </div>
                            <div class="form-group col-sm-12">
                                <label class="control-label  col-sm-3">ჯგუფი</label>
                                <div class="col-sm-9">
                                    <select class="form-control input-sm" ng-model="user.userGroupId">
                                        <option ng-repeat="g in userGroups" value="{{g.id}}">{{g.description}}</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group col-sm-12">
                                <label class="control-label  col-sm-3">სტატუსი</label>
                                <div class="col-sm-9">
                                    <select class="form-control input-sm" ng-model="user.userStatusId">
                                        <option ng-repeat="g in userStatuses" value="{{g.id}}">{{g.name}}</option>
                                    </select>
                                </div>
                            </div>

                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="addUser()">შენახვა</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade bs-example-modal-md" id="budgetModal" tabindex="-1" role="dialog"
         aria-labelledby="addIdNumberLabel" aria-hidden="true">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="budgetLabel">ბიუჯეტის შევსება</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label  col-sm-3">წელი</label>
                                <div class="col-sm-9">
                                    <select class="form-control input-sm" ng-model="budget.yearId">
                                        <option ng-repeat="y in years" value="{{y.id}}">{{y.name}}</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-3">გამოყოფილი ბიჯეტი</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control input-sm"
                                           ng-model="budget.budget">
                                </div>
                            </div>
                        </form>

                        <table class="table table-striped table-hover" id="budgetList">
                            <tr>
                                <th>ID</th>
                                <th>წელი</th>
                                <th>ბიუჯეტი</th>
                                <th></th>
                            </tr>
                            <tr ng-repeat="i in userBudgets">
                                <td>{{$index + 1}}</td>
                                <td>{{i.years.name}}</td>
                                <td>{{i.budget}}</td>
                                <td>
                                    <button type="button" class="btn btn-xs" ng-click="deleteUserBudget(i.id)">
                                        <span class="glyphicon glyphicon-remove"></span>
                                    </button>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="addUserBudget()">დამატება</button>
                </div>
            </div>
        </div>
    </div>


    <div class="row">
        <div class="form-group col-sm-4">
            <div class="col-sm-9">
                <input type="text" placeholder="ძიება..." ng-model="searchFish" class="form-control input-sm">
            </div>
        </div>
        <div class="form-group col-sm-2 col-md-offset-6 text-right">
            <label class="control-label"></label>
            <button type="button" class="btn btn-primary btn-xs"
                    data-toggle="modal" data-target="#addPersonModal" ng-click="selectUser()">
                დამატება
            </button>
        </div>
    </div>
    <table class="table table-striped table-hover" id="userList">
        <tr>
            <th>ID</th>
            <th>სახელი</th>
            <th>საიდ. N</th>
            <th>ელ-ფოსტა</th>
            <th>ტელეფონი</th>
            <th>მისამართი</th>
            <th>ჯგუფი</th>
            <th>სტატუსი</th>
            <th></th>
        </tr>
        <tr ng-repeat="i in users| filter:searchFish">
            <td>{{$index + 1}}</td>
            <td>{{i.name}}</td>
            <td>{{i.idNumber}}</td>
            <td>{{i.email}}</td>
            <td>{{i.phone}}</td>
            <td>{{i.address}}</td>
            <td>{{i.usersGroup.description}}</td>
            <td>{{i.usersStatus.name}}</td>
            <td width="120">
                <button type="button" class="btn btn-xs" data-toggle="modal" data-target="#addPersonModal"
                        ng-click="editUser(i.id)">
                    <span class="glyphicon glyphicon-pencil"></span>
                </button>
                <button type="button" class="btn btn-xs" ng-click="deleteUser(i.id)">
                    <span class="glyphicon glyphicon-remove"></span>
                </button>
            </td>
        </tr>
    </table>

</div>
<%@include file="footer.jsp" %>
