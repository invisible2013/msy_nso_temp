<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="header2.jsp" %>
<script>
    var app = angular.module("app", []);
    app.controller("userCtrl", function ($scope, $http, $filter) {
        $scope.user = {'userGroupId': 1, 'userStatusId': 1};
        $scope.users = [];
        $scope.years = [];
        $scope.userBudgets = [];
        $scope.budget = {};
        $scope.supervisors = [];

        function getUsers(res) {
            $scope.users = res.data;
            $scope.supervisors = JSON.parse(JSON.stringify(res.data));
            var a = {id: 0,name:'Choose Supervisor', usersGroup: {id: 3}};
            $scope.supervisors.push(a);
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
            function uploadImage(res) {
                if ($('#documentId')[0].files[0]) {
                    var oMyForm = new FormData();
                    oMyForm.append("userId", res.data.id);
                    oMyForm.append("files", $('#documentId')[0].files[0]);
                    $.ajax({
                        url: 'users/add-user-image',
                        data: oMyForm,
                        dataType: 'text',
                        processData: false,
                        contentType: false,
                        type: 'POST',
                        success: function (data) {
                            Modal.info("The operation completed successfully", function () {
                                location.reload();
                            })
                        },
                        error: function (data, status, headers, config) {
                            location.reload();
                        }
                    });
                }
                location.reload();
            }

            ajaxCall($http, "users/add-user", angular.toJson($scope.user), uploadImage);
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
            Modal.confirm("You need to confirm this operation", function () {
                ajaxCall($http, "user/delete-user", angular.toJson($scope.user), reload);
            })
        };
        $scope.addUserBudget = function () {
            ajaxCall($http, "users/add-user-budget", angular.toJson($scope.budget), reload);
        };
        $scope.deleteUserBudget = function (userId) {
            Modal.confirm("You need to confirm this operation", function () {
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

        $scope.tpFilter = function (item) {
            if (item.usersGroup.id == 3) {
                return true;
            }
        };

        $scope.managerFilter = function (item) {
            if (item.usersGroup.id == 7) {
                return true;
            }
        };

    });
</script>


<div ng-controller="userCtrl">

    <div class="modal fade" id="addPersonModal" tabindex="-1" role="dialog"
         aria-labelledby="addIdNumberLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="title" id="addIdNumberLabel">Detail Information</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="row form-horizontal col-md-12">
                            <div class="form-group col-sm-12">
                                <label>Name</label>
                                <input type="text" ng-model="user.name" class="form-control input-sm">
                            </div>
                            <div class="form-group col-sm-12">
                                <label>Id Number</label>
                                <input type="text" ng-model="user.idNumber" class="form-control input-sm">
                            </div>
                            <div class="form-group col-sm-6">
                                <label>Email</label>
                                <input type="text" id="email" ng-model="user.email" class="form-control input-sm">
                            </div>
                            <div class="form-group col-sm-6">
                                <label>Password</label>
                                <input type="password" id="pass" ng-model="user.password"
                                       class="form-control input-sm">
                            </div>
                            <div class="form-group col-sm-6">
                                <label>Phone</label>
                                <input type="text" id="phone" ng-model="user.phone" class="form-control input-sm">
                            </div>
                            <div class="form-group col-sm-6">
                                <label>Second Phone</label>
                                <input type="text" id="phone2" ng-model="user.phone2" class="form-control input-sm">
                            </div>
                            <div class="form-group col-sm-12">
                                <label>Address</label>
                                <input type="text" id="address" ng-model="user.address"
                                       class="form-control input-sm">
                            </div>
                            <div class="form-group col-sm-12">
                                <label>Picture</label>
                                <input type="file" id="documentId" name="file"
                                       class="form-control input-sm upload-file">
                            </div>
                            <div class="form-group col-sm-6">
                                <label>User Group</label>
                                <select class="form-control input-sm" ng-model="user.userGroupId">
                                    <option ng-repeat="g in userGroups" value="{{g.id}}">{{g.description}}</option>
                                </select>
                            </div>
                            <div class="form-group col-sm-6">
                                <label>Status</label>
                                <select class="form-control input-sm" ng-model="user.userStatusId">
                                    <option ng-repeat="g in userStatuses" value="{{g.id}}">{{g.name}}</option>
                                </select>
                            </div>
                            <div class="form-group col-sm-12" ng-show="user.userGroupId==4">
                                <label>Supervisor</label>
                                <select class="form-control input-sm" ng-model="user.supervisorId">
                                    <option ng-repeat="u in supervisors|filter:tpFilter" value="{{u.id}}">{{u.name}}
                                    </option>
                                </select>
                            </div>
                            <div class="form-group col-sm-12" ng-show="user.userGroupId==4">
                                <label>Manager</label>
                                <select class="form-control input-sm" ng-model="user.managerId">
                                    <option ng-repeat="u in users|filter:managerFilter" value="{{u.id}}">{{u.name}}
                                    </option>
                                </select>
                            </div>

                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="addUser()">Save</button>
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
                    <h4 class="modal-title" id="budgetLabel">Budget Information</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label  col-sm-3">Year</label>
                                <div class="col-sm-9">
                                    <select class="form-control input-sm" ng-model="budget.yearId">
                                        <option ng-repeat="y in years" value="{{y.id}}">{{y.name}}</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-3">Budget</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control input-sm"
                                           ng-model="budget.budget">
                                </div>
                            </div>
                        </form>

                        <table class="table table-striped table-hover" id="budgetList">
                            <tr>
                                <th>ID</th>
                                <th>Year</th>
                                <th>Budget</th>
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
                    <button type="button" class="btn btn-primary btn-xs" ng-click="addUserBudget()">Save</button>
                </div>
            </div>
        </div>
    </div>


    <!-- Main Content -->
    <section class="content">
        <div class="block-header">
            <div class="row">
                <div class="col-lg-7 col-md-6 col-sm-12">
                    <h2>Users
                        <small>Information</small>
                    </h2>
                </div>
                <div class="col-lg-5 col-md-6 col-sm-12">
                    <button class="btn btn-white btn-icon btn-round hidden-sm-down float-right m-l-10" type="button"
                            data-toggle="modal" data-target="#addPersonModal" ng-click="selectUser()">
                        <i class="zmdi zmdi-plus"></i>
                    </button>
                    <ul class="breadcrumb float-md-right">
                        <li class="breadcrumb-item"><a href="home"><i class="zmdi zmdi-home"></i> Nso</a></li>
                        <li class="breadcrumb-item active">Users</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="container-fluid">
            <div class="row clearfix">
                <div class="col-lg-12">
                    <div class="card">
                        <div class="body">


                            <div class="row">
                                <div class="form-group col-sm-4">
                                    <div class="col-sm-9">
                                        <input type="text" placeholder="Search..." ng-model="searchFish"
                                               class="form-control input-sm">
                                    </div>
                                </div>
                                <%-- <div class="form-group col-sm-2 col-md-offset-6 text-right">
                                     <label class="control-label"></label>
                                     <button type="button" class="btn btn-primary btn-xs"
                                             data-toggle="modal" data-target="#addPersonModal" ng-click="selectUser()">
                                         დამატება
                                     </button>
                                 </div>--%>
                            </div>
                            <table class="table table-striped table-hover" id="userList">
                                <tr>
                                    <th>ID</th>
                                    <th>Status</th>
                                    <th>Name</th>
                                    <th>Id Number</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Address</th>
                                    <th>Group</th>
                                    <th></th>
                                </tr>
                                <tr ng-repeat="i in users| filter:searchFish">
                                    <td>{{$index + 1}}</td>
                                    <td><span
                                            ng-class="{'badge badge-danger': (i.usersStatus.id == 2),'badge badge-success': (i.usersStatus.id == 1)}">{{i.usersStatus.name}}</span>
                                    </td>
                                    <td>{{i.name}}</td>
                                    <td>{{i.idNumber}}</td>
                                    <td>{{i.email}}</td>
                                    <td>{{i.phone}}</td>
                                    <td>{{i.address}}</td>
                                    <td>{{i.usersGroup.description}}</td>
                                    <td width="120">
                                        <button type="button" class="btn btn-neutral-purple btn-icon btn-sm"
                                                data-toggle="modal" data-target="#addPersonModal"
                                                ng-click="editUser(i.id)">
                                            <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-icon btn-neutral"
                                                ng-click="deleteUser(i.id)">
                                            <i class="zmdi zmdi-delete zmdi-hc-fw"></i>
                                        </button>
                                    </td>
                                </tr>
                            </table>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>


<%@include file="footer2.jsp" %>