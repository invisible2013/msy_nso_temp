<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <base href="${pageContext.request.contextPath}/"/>

    <link rel="stylesheet" href="resources/css/jquery-ui.css"/>
    <link rel="stylesheet" href="resources/css/style.css">
    <link rel="shortcut icon" href="resources/imgs/favicon.ico">
    <script type="text/javascript" src="resources/js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="resources/js/jquery-ui.js"></script>
    <script type="text/javascript" src="resources/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="resources/js/angular.min.js"></script>
    <script src="resources/js/ui-bootstrap-0.14.3.js" type="text/javascript"></script>
    <script type="text/javascript" src="resources/js/global_error_handler.js"></script>
    <script type="text/javascript" src="resources/js/global_util.js"></script>

    <link rel="stylesheet" href="resources/assets/plugins/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="resources/assets/css/main2.css">
    <link rel="stylesheet" href="resources/assets/css/color_skins.css">
    <script>
        var app = angular.module("app", []);
        app.controller("detailCtrl", function ($scope, $http, $filter, $location) {
            var absUrl = $location.absUrl();
            $scope.currentEventId = 0;
            $scope.currentEventkey = 0;
            if (absUrl.split("?")[1]) {
                $scope.currentEventkey = absUrl.split("?")[1].split("=")[1];
            }
            if ($scope.currentEventkey != 0) {
                function getEvent(res) {
                    $scope.detailInfo = res.data;
                    $scope.persons = res.data.persons;
                    $scope.documents = res.data.documents;
                }

                ajaxCall($http, "event/get-event-by-key", {key: $scope.currentEventkey}, getEvent);
                function getEventHistory(res) {
                    $scope.history = res.data;
                }

                ajaxCall($http, "event/get-event-history-by-key", {key: $scope.currentEventkey}, getEventHistory);
            }
            function getPersonTypes(res) {
                $scope.personTypes = res.data;
            }

            ajaxCall($http, "misc/get-person-types", {}, getPersonTypes);
            $scope.getCategory = function (id) {
                return $filter('filter')($scope.personTypes, {id: id}, true)[0].name;
            };
            $scope.open = function (name) {
                if (name.indexOf('.pdf') >= 0) {
                    window.open('file/draw/' + name + '/');
                } else {
                    window.open('file/download/' + name + '/');
                }
            };
        });
        function printDetail() {
            var printContents = document.getElementById('printInformation').innerHTML;
            var originalContents = document.body.innerHTML;
            document.body.innerHTML = printContents;
            window.print();
            document.body.innerHTML = originalContents;
        }
        function hideModal() {
            window.location.reload();
        }
    </script>
</head>
<body ng-app="app">

    <div class="container-fluid" ng-controller="detailCtrl">
        <div class="row clearfix">
            <div class="col-md-10">
                <div class="card">
                    <div class="body">

                        <div style="margin-left: 15px;margin-bottom: 10px">
                            <h4 id="detailModalLabel"><b>Detail Information: </b><b class="text-primary">#</b><strong class="text-primary">{{detailInfo.eventName}}</strong></h4>

                            <button class="btn btn-warning btn-icon  btn-icon-mini btn-round" onclick="printDetail();"><i class="zmdi zmdi-print"></i></button>
                        </div>
                        <div id="printInformation">
                            <div class="col-md-12">
                                <table class="table table-striped" ng-show="detailInfo.applicationType.id == 2">
                                    <tr>
                                        <td style="width: 20%" class="text-right">Federation :</td>
                                        <td style="width: 80%">{{detailInfo.senderUser.name}}</td>
                                    </tr>
                                    <tr>
                                        <th class="text-right">Application:</th>
                                        <td>{{detailInfo.eventName}}</td>
                                    </tr>
                                    <tr>
                                        <th class="text-right">Event Type :</th>
                                        <td>{{detailInfo.eventType.name}}</td>
                                    </tr>
                                    <tr>
                                        <th class="text-right">Number :</th>
                                        <td>{{detailInfo.letterNumber}}</td>
                                    </tr>
                                    <tr>
                                        <th class="text-right">Budget :</th>
                                        <td>{{detailInfo.budget}}</td>
                                    </tr>
                                </table>
                                <table class="table table-striped" ng-show="detailInfo.applicationType.id == 1">
                                    <tr>
                                        <th style="width: 20%" class="text-right">Federation :</th>
                                        <td style="width: 80%">{{detailInfo.senderUser.name}}</td>
                                    </tr>
                                    <tr>
                                        <th class="text-right">Application:</th>
                                        <td>{{detailInfo.eventName}}</td>
                                    </tr>
                                    <tr>
                                        <th class=" text-right">Description :</th>
                                        <td>{{detailInfo.eventDescription}}</td>
                                    </tr>
                                    <tr>
                                        <th class="text-right">Purpose :</th>
                                        <td>{{detailInfo.purpose}}</td>
                                    </tr>
                                    <tr>
                                        <th class=" text-right">Expected Result :</th>
                                        <td>{{detailInfo.expectedResult}}</td>
                                    </tr>
                                    <tr>
                                        <th class="text-right">Start Date :</th>
                                        <td>{{detailInfo.startDate}}</td>
                                    </tr>
                                    <tr>
                                        <th class="text-right">End Date :</th>
                                        <td>{{detailInfo.endDate}}</td>
                                    </tr>
                                    <tr>
                                        <th class="text-right">Date of reports :</th>
                                        <td>{{detailInfo.reportDeliveryDate}}</td>
                                    </tr>
                                    <tr>
                                        <th class="text-right">Budget :</th>
                                        <td>{{detailInfo.budget}} GEL</td>
                                    </tr>
                                    <tr>
                                        <th class="text-right">Real Amount :</th>
                                        <td>{{detailInfo.realAmount}} GEL</td>
                                    </tr>
                                    <tr>
                                        <th class="text-right">Responsible person :</th>
                                        <td>{{detailInfo.responsiblePerson}}, {{detailInfo.responsiblePersonPosition}}</td>
                                    </tr>
                                    <tr>
                                        <th class="text-right">Application Type :</th>
                                        <td>{{detailInfo.eventType.name}}</td>
                                    </tr>
                                </table>
                                <div class="form-group"><br/></div>
                            </div>
                            <div class="col-md-12" ng-show="persons.length > 0">
                                <h4>Participants</h4>
                                <hr>
                                <table class="table table-striped">
                                    <tr>
                                        <th>#</th>
                                        <th>Participant</th>
                                        <th>Personal N</th>
                                        <th>DOB</th>
                                        <th>Club</th>
                                        <th>Position</th>
                                        <th>Sport</th>
                                        <th>City/District</th>
                                        <th>Coach</th>
                                        <th>Category</th>
                                    </tr>
                                    <tr ng-repeat="x in persons">
                                        <td>{{$index + 1}}</td>
                                        <td>
                                            <a class="m-r-10" ng-click="open(x.imageUrl);">
                                                <img src="file/draw/{{x.optimizedImageUrl}}/"
                                                     class="rounded-circle avatar"
                                                     style="height: 50px; width: 50px;"
                                                >
                                            </a>
                                             {{ x.firstName}} {{ x.lastName}}( {{getCategory(x.type)}} )
                                        </td>
                                        </td>
                                        <td>{{ x.personalNumber}}</td>
                                        <td>{{ x.birthDate| date:'dd/MM/yyyy'}}</td>
                                        <td>{{ x.club}}</td>
                                        <td>{{ x.position}}</td>
                                        <td>{{ x.category}}</td>
                                        <td>{{ x.city}}</td>
                                        <td>{{ x.trainer}}</td>
                                        <td>{{ x.weightCategory}}</td>
                                    </tr>
                                </table>
                                <div class="form-group"><br/></div>
                            </div>
                        </div>
                        <div class="col-md-12" ng-show="documents.length > 0">
                            <h4>Documents</h4>
                            <hr>
                            <table class="table table-striped">
                                <tr>
                                    <th>#</th>
                                    <th>Document Type</th>
                                    <th>File</th>
                                </tr>
                                <tr ng-repeat="d in documents">
                                    <td>{{$index + 1}}</td>
                                    <td>{{ d.type.name}}</td>
                                    <td><a class=" btn-link text-info"
                                           ng-click="open(d.name);">{{d.name}}</a></td>
                                </tr>
                            </table>
                            <div class="form-group"><br/></div>
                        </div>
                        <div class="col-sm-12" ng-show="history.length > 0">
                            <h4><b>History</b></h4>
                            <hr>
                            <table class="table table-striped">
                                <tr>
                                    <th>#</th>
                                    <th>Sender User</th>
                                    <th>Receiver </th>
                                    <th>Status</th>
                                    <th>Note</th>
                                    <th>Create Date</th>
                                </tr>
                                <tr ng-repeat="h in history">
                                    <td>{{$index + 1}}</td>
                                    <td>{{h.sender.name}}</td>
                                    <td>{{h.recipient.name}}</td>
                                    <td>{{h.status.description}}</td>
                                    <td>{{h.note}}</td>
                                    <td>{{h.createDate}}</td>
                                </tr>
                            </table>
                            <div class="form-group"><br/></div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>







</body>
</html>