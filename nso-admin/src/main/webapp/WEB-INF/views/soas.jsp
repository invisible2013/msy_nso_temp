<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="header2.jsp" %>

<script>

    var app = angular.module("app", ["ui.bootstrap"]);
    app.factory('Excel', function ($window) {
        var uri = 'data:application/vnd.ms-excel;base64,',
            template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head>' +
                '</head><body><table>{table}</table></body></html>',
            base64 = function (s) {
                return $window.btoa(unescape(encodeURIComponent(s)));
            },
            format = function (s, c) {
                return s.replace(/{(\w+)}/g, function (m, p) {
                    return c[p];
                })
            };
        return {
            tableToExcel: function (tableId, worksheetName) {
                var table = $(tableId),
                    ctx = {worksheet: worksheetName, table: table.html()},
                    href = uri + base64(format(template, ctx));
                return href;
            }
        };
    });

    app.controller("messageCtrl", function ($scope, $http, $filter, Excel, $timeout) {
        $scope.currentUserId = 0;
        $scope.years = [];
        $scope.events = [];
        $scope.search = [];
        $scope.start = 0;
        $scope.limit = 40;
        $scope.size = 0;

        var currentYear = new Date().getFullYear();
        for (var a = 2016; a <= currentYear; a++) {
            $scope.years.push({id: a, name: a});
        }

        function isEmptyValue(variable) {
            return variable == undefined || variable == null || variable.length == 0;
        };

        $scope.search = {offset: $scope.start, limit: $scope.limit};

        function getAnnualReports(res) {
            $scope.events = $scope.events.concat(res.data);
            $scope.size = res.data.length;
        }

        ajaxCall($http, "soas/get-annual-report", angular.toJson({statusId: 1}), getAnnualReports);


        function getUser(res) {
            $scope.current = res.userData;
            $scope.currentUserId = $scope.current.id;
        }

        ajaxCall($http, "get-user", {}, getUser);


        $scope.loadMore = function () {
            $scope.search.offset = $scope.search.offset + $scope.search.limit;
            ajaxCall($http, "soas/get-annual-report", angular.toJson($scope.search), getAnnualReports, null, "requestList");
        };

        $scope.loadAll = function () {
            $scope.search.offset = $scope.search.offset + $scope.search.limit;
            $scope.search.limit = 1000000;
            ajaxCall($http, "soas/get-annual-report", angular.toJson($scope.search), getAnnualReports, null, "requestList");
        };

        $scope.searchChange = function () {
            $scope.search.offset = $scope.start;
            $scope.search.limit = $scope.limit;
            $scope.events = [];
            ajaxCall($http, "soas/get-annual-report", angular.toJson($scope.search), getAnnualReports, null, "requestList");
        };


        $scope.infoEvent = function (eventKey) {
            window.open("detailInfo?Id=" + eventKey, "_blank");
        };


        $scope.selectEvent = function (messageId) {
            $scope.targetEventRequest = {messageId: messageId};
        };
        $scope.detailMessage = function (item) {
            $scope.detailInfo = item;

        };


        $scope.sendResponseMessage = function () {
            if (isEmptyValue($scope.targetEventRequest.note)) {
                Modal.info('Enter Note');
                return;
            }

            var data = angular.toJson($scope.targetEventRequest).toString();

            var oMyForm = new FormData();
            oMyForm.append("data", data);
            oMyForm.append("files", $('#documentId')[0].files[0]);

            $.ajax({
                url: 'message/response-message',
                data: oMyForm,
                dataType: 'text',
                processData: false,
                contentType: false,
                type: 'POST',
                success: function (data) {
                    $("#beArea").removeClass("loading-mask");
                    Modal.info("The operation completed successfully", function () {
                        location.reload();
                    })
                },
                error: function (data, status, headers, config) {
                    $("#beArea").removeClass("loading-mask");
                    location.reload();
                }
            });
            $("#beArea").addClass('loading-mask');
        };

        $scope.open = function (name) {
            window.open('file/draw/' + name + '/');
        };

        $scope.addAnnualReport = function () {
            window.open("addAnnual");
        };

        $scope.exportToExcel = function (tableId) { //
            $scope.exportHref = Excel.tableToExcel(tableId, 'events');
            $timeout(function () {
                window.open($scope.exportHref);
            }, 100); // trigger download
        }

        $scope.sendDocument = function (itemId) {
            window.location = "soasDocuments?itemId=" + itemId;
        };


        $scope.editReport = function (itemId) {
            window.location = "addAnnual?itemId=" + itemId;
        };

        $scope.selectEvent = function (itemId) {
            $scope.targetRequest = {id: itemId};
        };

        $scope.blockReport = function (itemId) {
            ajaxCall($http, "soas/block-report", angular.toJson($scope.targetRequest), reload);
        };

        $scope.sendReport = function (itemId) {
            if (confirm("Confirm operation")) {
                $scope.targetRequest = {id: itemId};
                ajaxCall($http, "soas/send-report", angular.toJson($scope.targetRequest), reload);
            }
        };


    });
</script>

<div ng-controller="messageCtrl" id="beArea">

    <div class="modal fade" id="infoModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="title">Annual Report</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="col-md-12">
                            <table class="table table-striped col-md-12">
                                <tr>
                                    <th class="">Create Date :</th>
                                    <td>{{detailInfo.createDate}}</td>
                                </tr>
                                <tr>
                                    <th class="">Year :</th>
                                    <td>{{detailInfo.year}}</td>
                                </tr>
                                <tr>
                                    <th class="">Sender :</th>
                                    <td>{{detailInfo.senderUser.name}}</td>
                                </tr>
                                <tr>
                                    <th class="">Introduction :</th>
                                    <td>{{detailInfo.introduction}}</td>
                                </tr>
                                <tr>
                                    <th class="">Results :</th>
                                    <td>{{detailInfo.result}}</td>
                                </tr>
                                <tr>
                                    <th class="">Good governance :</th>
                                    <td>{{detailInfo.governance}}</td>
                                </tr>
                                <tr>
                                    <th class="">Increase of qualification :</th>
                                    <td>{{detailInfo.qualification}}</td>
                                </tr>
                                <tr>
                                    <th class="">Promotion :</th>
                                    <td>{{detailInfo.popularisation}}</td>
                                </tr>
                                <tr>
                                    <th class="">Fight against doping, match-fixing, manipulations, violance an discrimination in sport :
                                    </th>
                                    <td>{{detailInfo.fight}}</td>
                                </tr>
                                <tr>
                                    <th class="">Gender issues :</th>
                                    <td>{{detailInfo.genderIssue}}</td>
                                </tr>
                                <tr>
                                    <th class="">Alternative funding :</th>
                                    <td>{{detailInfo.alternative}}</td>
                                </tr>
                                <tr>
                                    <th class="">Grassroots :</th>
                                    <td>{{detailInfo.mass}}</td>
                                </tr>
                                <tr>
                                    <th class="">Conclusion :</th>
                                    <td>{{detailInfo.conclusion}}</td>
                                </tr>

                                <tr class="red-text">
                                    <th class="">Note :</th>
                                    <td>{{detailInfo.note}}</td>
                                </tr>

                            </table>
                            <div class="col-sm-12" ng-show="detailInfo.documents.length > 0">
                                <h4><b>დოკუმენტები</b></h4>
                                <hr>
                                <table class="table table-striped">
                                    <tr>
                                        <th>#</th>
                                        <th>Type</th>
                                        <th>File</th>
                                    </tr>
                                    <tr ng-repeat="h in detailInfo.documents">
                                        <td>{{$index + 1}}</td>
                                        <td>{{h.type.name}}</td>
                                        <td><a class="btn-link text-info"
                                               ng-click="open(h.name);">{{h.name}}</a></td>
                                    </tr>
                                </table>
                                <div class="form-group"><br/></div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default waves-effect" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="rejectModal" tabindex="-1" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="title">Block</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <form class="col-md-12">
                            <label>Note</label>
                            <div class="form-group">
                                    <textarea class="form-control input-group-sm" rows="2"
                                              ng-model="targetRequest.note"></textarea>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" ng-click="blockReport()">Send</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <section class="content">
        <div class="block-header">
            <div class="row">
                <div class="col-lg-7 col-md-6 col-sm-12">
                    <h2>SOAS Annual Report
                        <small>Annual Report</small>
                    </h2>
                </div>
                <div class="col-lg-5 col-md-6 col-sm-12">
                    <%if (hasPermissions(request, Groups.FEDERATION.getName())) {%>
                    <button class="btn btn-white btn-icon btn-round hidden-sm-down float-right m-l-10" type="button"
                            ng-click="addAnnualReport()">
                        <i class="zmdi zmdi-plus"></i>
                    </button>
                    <%}%>
                    <ul class="breadcrumb float-md-right">
                        <li class="breadcrumb-item"><a href="home"><i class="zmdi zmdi-home"></i> Nso</a></li>
                        <li class="breadcrumb-item active"> Annual Report</li>
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
                                    <div class="form-group" style="margin-top:8px;">
                                        <input type="text" class="form-control"
                                               ng-model="search.fullText">
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <button class="btn btn-raised btn-primary btn-round waves-effect m-l-20"
                                                ng-click="searchChange()">Search
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group text-right">
                                        <button class="btn btn-sm btn-icon btn-neutral-purple"
                                                ng-click="exportToExcel('#requestList')"
                                                title="Download Excel">
                                            <i class="zmdi zmdi-download"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <table id="requestList" style="display: none;">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Federation</th>
                                    <th>Year</th>
                                    <th>Introduciton</th>
                                    <th>Results</th>
                                    <th>Good governance</th>
                                    <th>Increase of qualification</th>
                                    <th>Promotion</th>
                                    <th>Fight against doping, match-fixing, manipulations, violance an discrimination in sport
                                    </th>
                                    <th>Gender issues</th>
                                    <th>Alternative funding</th>
                                    <th>Grassroots</th>
                                    <th>Conclusion</th>
                                    <th></th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr ng-repeat="i in events">
                                    <th><span>{{$index + 1}}</span>
                                    </th>
                                    <td>{{i.senderUser.name}}</td>
                                    <td>{{i.year}}</td>
                                    <td>{{i.introduction}}</td>
                                    <td>{{i.result}}</td>
                                    <td>{{i.governance}}</td>
                                    <td>{{i.qualification}}</td>
                                    <td>{{i.popularisation}}</td>
                                    <td>{{i.fight}}</td>
                                    <td>{{i.genderIssue}}</td>
                                    <td>{{i.alternative}}</td>
                                    <td>{{i.mass}}</td>
                                    <td>{{i.conclusion}}</td>
                                </tr>
                                </tbody>
                            </table>
                            <table class="table table-hover">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Federation</th>
                                    <th>Year</th>
                                    <th>Introduction</th>
                                    <th>Results</th>
                                    <th>Conclusion</th>
                                    <th>Status</th>
                                    <th></th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr ng-repeat="i in events">
                                    <th><span>{{$index + 1}}</span>
                                    </th>
                                    <td>{{i.senderUser.name}}</td>
                                    <td>{{i.year}}</td>
                                    <td>{{i.introduction}}</td>
                                    <td>{{i.result}}</td>
                                    <td>{{i.conclusion}}</td>
                                    <td>
                                        <span ng-class="{'badge badge-danger': (i.annualReportStatus.id == 2),'badge badge-success': (i.annualReportStatus.id == 3)}">
                                        {{i.annualReportStatus.name}}</span></td>
                                    <td style="min-width: 123px; width: auto;">
                                        <button
                                                class="btn btn-sm btn-icon btn-neutral-purple"
                                                ng-click="detailMessage(i)"
                                                data-toggle="modal" data-target="#infoModal"
                                                title="detail info">
                                            <i class="zmdi zmdi-info"></i></button>
                                        <span ng-show="<%=hasPermissions(request, Groups.FEDERATION.getName())%>">
                                        <button
                                                type="button"
                                                class="btn btn-icon btn-sm btn-neutral-purple"
                                                title="upload documents"
                                                ng-click="sendDocument(i.id)">
                                            <i class="zmdi zmdi-file"></i>
                                        </button>
                                        </span>
                                        <span ng-show="<%=hasPermissions(request, Groups.FEDERATION.getName())%>">
                                            <button ng-show="i.annualReportStatus.id == 1 ||i.annualReportStatus.id == 2"
                                                    type="button" class="btn btn-sm btn-icon btn-neutral-purple"
                                                    title="edit"
                                                    ng-click="editReport(i.id)">
                                                 <i class="zmdi zmdi-edit zmdi-hc-fw"></i>
                                            </button>
                                        </span>
                                        <span ng-show="<%=hasPermissions(request, Groups.MANAGER.getName())%>">
                                            <button ng-show="i.annualReportStatus.id == 1 || i.annualReportStatus.id == 4"
                                                    type="button" class="btn btn-sm btn-icon btn-neutral-purple"
                                                    title="Accept"
                                                    ng-click="sendReport(i.id)">
                                                 <i class="zmdi zmdi-check"></i>
                                            </button>
                                        </span>
                                        <span ng-show="<%=hasPermissions(request, Groups.MANAGER.getName())%>">
                                            <button ng-show="i.annualReportStatus.id == 1 || i.annualReportStatus.id == 4"
                                                    type="button" class="btn btn-sm btn-icon btn-neutral"
                                                    title="Block" data-toggle="modal"
                                                    data-target="#rejectModal"
                                                    ng-click="selectEvent(i.id)">
                                                 <i class="zmdi zmdi-block"></i>
                                            </button>
                                        </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>

                            <div class="col-md-12">
                                <br/>
                                <input type="button" ng-show="size2>=limit" class="btn btn-primary btn-xs"
                                       value="Load More"
                                       ng-click="loadMore2();">
                                <input type="button" ng-show="size2>=limit" class="btn btn-primary btn-xs"
                                       value="Load All"
                                       ng-click="loadAll2();">
                            </div>


                        </div>
                    </div>

                </div>
            </div>
        </div>
    </section>


</div>

<%@include file="footer2.jsp" %>