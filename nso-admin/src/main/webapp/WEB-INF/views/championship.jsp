<%@page contentType="text/html" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="resources/css/bootstrap-datepicker.css"/>
<%@include file="header2.jsp" %>
<link href="resources/css/select2.min.css" rel="stylesheet"/>


<script>
    var app = angular.module("app", []);
    app.controller("championshipCtrl", function ($scope, $http, $filter) {
        $scope.sportTypeRow = [1];

        $scope.searchText = "";
        $scope.start = 0;
        $scope.limit = 40;
        $scope.size = 0;
        $scope.loadCount = 0;
        $scope.items = [];

        function getSuccessItems(res) {
            $scope.items = $scope.items.concat(res.data);
            $scope.size = res.data.size;
            $scope.loadCount = $scope.items.length;
        }

        ajaxCall($http, "championship/get-championships?start=" + $scope.start + "&limit=" + $scope.limit, null, getSuccessItems);


        function getSuccessRegions(res) {
            $scope.championshipTypes = res.data;
        }

        ajaxCall($http, "championship/get-championship-types", null, getSuccessRegions);


        $scope.getChampionshipSubTypes = function () {
            function getSuccessCities(res) {
                $scope.championshipSubTypes = res.data;
            }

            ajaxCall($http, "championship/get-championship-sub-types?typeId=" + $scope.item.championshipTypeId, null, getSuccessCities);
        };


        $scope.addNewSportsman = function () {
            $scope.item = {'championshipTypeId': 1};
            $scope.getChampionshipSubTypes();
        };

        $scope.saveItem = function () {
            $scope.item.startDate = $('#startDate').val();
            $scope.item.endDate = $('#endDate').val();
            console.log($scope.item);
            function saveSuccessItem(res) {
                console.log(res);
                location.reload();
            };
            ajaxCall($http, "championship/save-championship", angular.toJson($scope.item), saveSuccessItem);
        };


        $scope.detailEvent = function (eventId) {
            function getEvent(res) {
                console.log(res.data);
                $scope.detailInfo = res.data;
                $scope.persons = res.data.persons;
                $scope.documents = res.data.documents;
            }

            ajaxCall($http, "event/get-event", angular.toJson({'eventId': eventId}), getEvent);
            function getEventHistory(res) {
                $scope.history = res.data;
            }

            ajaxCall($http, "event/get-event-history", angular.toJson({'eventId': eventId}), getEventHistory);
        };
        $scope.editItem = function (itemId) {
            if (itemId != undefined) {
                var selected = $filter('filter')($scope.items, {id: itemId}, true);
                var temp = selected[0];

                function getSuccessSubTypes(res) {
                    $scope.championshipSubTypes = res.data;
                    $scope.item = temp;
                }

                ajaxCall($http, "championship/get-championship-sub-types?typeId=" + temp.championshipTypeId, null, getSuccessSubTypes);
            }
        };
        $scope.deleteItem = function (itemId) {
            if (confirm("You need to confirm this operation")) {
                if (itemId != undefined) {
                    ajaxCall($http, "championship/delete-championship?itemId=" + itemId, null, reload);
                }
            }
        };
        function setSelectByValue(eID, val) { //Loop through sequentially//
            var ele = $("#championshipSubType").options;
            for (var ii = 0; ii < ele.length; ii++)
                if (ele.options[ii].value == val) { //Found!
                    ele.options[ii].selected = true;
                    return true;
                }
            return false;
        }

        $scope.open = function (name) {
            window.open('file/draw/' + name + '/');
        };
        $scope.adSportTypeRow = function () {
            var size = $scope.sportTypeRow.length;
            $scope.sportTypeRow.push(size + 1);
            //$scope.sportTypeItems[size + 1] = $scope.sportTypeItems[1];
        };
        $scope.removeSportType = function (index) {
            $scope.sportTypeRow.splice(index, 1);
            $scope.item.sportTypes.splice(index, 1);
        };

        $scope.searchItem = function () {
            $scope.items = [];
            $scope.start = 0;
            $scope.limit = 40;
            ajaxCall($http, "championship/get-championships?start=" + $scope.start + "&limit=" + $scope.limit + "&searchText=" + $scope.searchText, null, getSuccessItems);
        }

        $scope.loadMore = function () {
            $scope.start = $scope.start + $scope.limit;
            ajaxCall($http, "championship/get-championships?start=" + $scope.start + "&limit=" + $scope.limit + "&searchText=" + $scope.searchText, null, getSuccessItems);
        };
        $scope.loadAll = function () {
            $scope.start = $scope.start + $scope.limit;
            $scope.limit = $scope.size;
            ajaxCall($http, "championship/get-championships?start=" + $scope.start + "&limit=" + $scope.limit + "&searchText=" + $scope.searchText, null, getSuccessItems);
        };

    });

</script>

<div ng-controller="championshipCtrl" id="eventControllerId">


    <div class="modal fade" id="addPersonModal" tabindex="-1" role="dialog"
         aria-labelledby="addIdNumberLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="title" id="addIdNumberLabel">Detail Information</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form name="sportsmanForm" class="row form-horizontal col-md-12" id="sportsmanPanel">
                            <div class="form-group col-md-12">
                                <label>Name</label>
                                <input type="text" ng-model="item.name" class="form-control input-sm"
                                       placeholder="Name">
                            </div>
                            <div class="form-group col-md-6">
                                <label>Start Date</label>
                                <input type="text" id="startDate" ng-model="item.startDate"
                                       class="form-control input-sm"
                                       placeholder="Start Date">
                            </div>
                            <div class="form-group col-md-6">
                                <label>End Date</label>
                                <input type="text" id="endDate" ng-model="item.endDate" class="form-control input-sm"
                                       placeholder="End Date">
                            </div>
                            <div class="form-group col-md-6">
                                <label>Championship Type</label>
                                <select class="form-control input-sm" ng-model="item.championshipTypeId"
                                        ng-change="getChampionshipSubTypes()">
                                    <option ng-repeat="r in championshipTypes" value="{{r.id}}">{{r.name}}</option>
                                </select>
                            </div>
                            <div class="form-group col-md-6">
                                <label>Championship Sub Type</label>
                                <select id="championshipSubType" class="form-control input-sm"
                                        ng-model="item.championshipSubTypeId">
                                    <option ng-repeat="s in championshipSubTypes"
                                            ng-selected="s.id==item.championshipSubTypeId"
                                            value="{{s.id}}">{{s.name}}
                                    </option>
                                </select>
                            </div>
                            <div class="form-group col-md-12">
                                <label>Description</label>
                                <input type="text" ng-model="item.description" class="form-control input-sm"
                                       placeholder="Description">
                            </div>
                            <div class="form-group col-md-12">
                                <label>Location</label>
                                <input type="text" ng-model="item.location" class="form-control input-sm"
                                       placeholder="Location">
                            </div>

                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-xs" ng-click="saveItem()">Save</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <section class="content">
        <div class="block-header">
            <div class="row">
                <div class="col-lg-7 col-md-6 col-sm-12">
                    <h2>Championship
                        <small>Add Championship</small>
                    </h2>
                </div>
                <div class="col-lg-5 col-md-6 col-sm-12">
                    <button class="btn btn-white btn-icon btn-round hidden-sm-down float-right m-l-10" type="button"
                            data-toggle="modal" data-target="#addPersonModal" ng-click="addNewSportsman()">
                        <i class="zmdi zmdi-plus"></i>
                    </button>
                    <ul class="breadcrumb float-md-right">
                        <li class="breadcrumb-item"><a href="home"><i class="zmdi zmdi-home"></i> Nso</a></li>
                        <li class="breadcrumb-item active">New Championship</li>
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
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <input type="text" class="form-control" placeholder="Search..."
                                               ng-model="searchText">
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <button class="btn btn-raised btn-primary btn-round waves-effect"
                                                style="margin-top: -3px;"
                                                ng-click="searchItem()">Search
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div id="sportsmanList">

                                <table class="table table-striped table-hover">
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                        <th></th>
                                    </tr>
                                    <tr ng-repeat="s in items">
                                        <td>{{$index+1}}</td>
                                        <td>{{s.name}}</td>
                                        <td>{{s.startDate}}</td>
                                        <td>{{s.endDate}}</td>
                                        <td style="min-width: 75px;">
                                            <button
                                                    type="button" class="btn btn-sm btn-icon btn-neutral-purple"
                                                    title="Edit"
                                                    data-toggle="modal"
                                                    data-target="#addPersonModal"
                                                    ng-click="editItem(s.id)">
                                                <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                            </button>
                                            <button type="button"
                                                    class="btn btn-icon btn-neutral btn-sm"

                                                    ng-click="deleteItem(s.id)">
                                                <i class="zmdi zmdi-delete zmdi-hc-fw"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </table>
                                <input type="button" ng-show="size>loadCount" class="btn btn-primary btn-xs"
                                       value="Load More"
                                       ng-click="loadMore();">
                                <input type="button" ng-show="size>loadCount" class="btn btn-primary btn-xs"
                                       value="Load All"
                                       ng-click="loadAll();">
                                <br/><br/>
                            </div>


                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>


<%@include file="footer2.jsp" %>

<script type="text/javascript" src="resources/js/bootstrap-datepicker.min.js"></script>
<script src="resources/js/select2.min.js"></script>
<script>
    $(document).ready(function () {

        $('.js-example-basic-single').select2();

        $('#startDate').datepicker({
            format: 'dd/mm/yyyy'
        });
        $('#endDate').datepicker({
            format: 'dd/mm/yyyy'
        });

    });
</script>