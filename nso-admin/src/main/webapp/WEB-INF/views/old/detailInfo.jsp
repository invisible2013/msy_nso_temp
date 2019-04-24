<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <base href="${pageContext.request.contextPath}/"/>
    <link rel="stylesheet" href="resources/css/bootstrap-yeti.min.css"/>
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
<div class="col-md-10" ng-controller="detailCtrl">

    <div style="margin-left: 15px;margin-bottom: 10px">
        <h4 id="detailModalLabel">დეტალური ინფორმაცია ({{detailInfo.eventName}})</h4>
        <button data-toggle="tooltip" title="ბეჭდვა" class="btn btn-xs text-right"
                onclick="printDetail();">
            <span class="glyphicon glyphicon-print"></span>
        </button>
    </div>
    <div id="printInformation">
        <div class="col-md-12">
            <table class="table table-striped" ng-show="detailInfo.applicationType.id == 2">
                <tr>
                    <th class="col-md-3 text-right">ფედერაცია :</th>
                    <td>{{detailInfo.senderUser.name}}</td>
                </tr>
                <tr>
                    <th class="col-md-3 text-right">Application:</th>
                    <td>{{detailInfo.eventName}}</td>
                </tr>
                <tr>
                    <th class="col-md-3 text-right">ღონისძიების ტიპი :</th>
                    <td>{{detailInfo.eventType.name}}</td>
                </tr>
                <tr>
                    <th class="col-md-3 text-right">წერილის N :</th>
                    <td>{{detailInfo.letterNumber}}</td>
                </tr>
                <tr>
                    <th class="col-md-3 text-right">ბიუჯეტი :</th>
                    <td>{{detailInfo.budget}}</td>
                </tr>
            </table>
            <table class="table table-striped" ng-show="detailInfo.applicationType.id == 1">
                <tr>
                    <th class="col-md-3 text-right">ფედერაცია :</th>
                    <td>{{detailInfo.senderUser.name}}</td>
                </tr>
                <tr>
                    <th class="col-md-3 text-right">Application:</th>
                    <td>{{detailInfo.eventName}}</td>
                </tr>
                <tr>
                    <th class="col-md-3 text-right">აღწერა :</th>
                    <td>{{detailInfo.eventDescription}}</td>
                </tr>
                <tr>
                    <th class="col-md-3 text-right">მიზანი :</th>
                    <td>{{detailInfo.purpose}}</td>
                </tr>
                <tr>
                    <th class="col-md-3 text-right">მოსალოდნელი შედეგი :</th>
                    <td>{{detailInfo.expectedResult}}</td>
                </tr>
                <tr>
                    <th class="col-md-3 text-right">დასაწყისი :</th>
                    <td>{{detailInfo.startDate}}</td>
                </tr>
                <tr>
                    <th class="col-md-3 text-right">დასასრული :</th>
                    <td>{{detailInfo.endDate}}</td>
                </tr>
                <tr>
                    <th class="col-md-3 text-right">ანგარიშის ჩაბარების თარიღი :</th>
                    <td>{{detailInfo.reportDeliveryDate}}</td>
                </tr>
                <tr>
                    <th class="col-md-3 text-right">ბიუჯეტი :</th>
                    <td>{{detailInfo.budget}} ლარი</td>
                </tr>
                <tr>
                    <th class="col-md-3 text-right">გადაცემული თანხა :</th>
                    <td>{{detailInfo.realAmount}} ლარი</td>
                </tr>
                <tr>
                    <th class="col-md-3 text-right">პასუხისმგებელი პირი, თანამდებობა :</th>
                    <td>{{detailInfo.responsiblePerson}}, {{detailInfo.responsiblePersonPosition}}</td>
                </tr>
                <tr>
                    <th class="col-md-3 text-right">ღონისძიების ტიპი :</th>
                    <td>{{detailInfo.eventType.name}}</td>
                </tr>
            </table>
            <div class="form-group"><br/></div>
        </div>
        <div class="col-md-12" ng-show="persons.length > 0">
            <h4>მონაწილეები</h4>
            <hr>
            <table class="table table-striped">
                <tr>
                    <th>#</th>
                    <th>მონაწილე</th>
                    <th>პირ. N</th>
                    <th>დ/წ</th>
                    <th>კლუბი</th>
                    <th>პოზიცია</th>
                    <th>სახეობა</th>
                    <th>ქალ/რაიონი</th>
                    <th>პირ/მწვრთ</th>
                    <th>წ/კ</th>
                </tr>
                <tr ng-repeat="x in persons">
                    <td>{{$index + 1}}</td>
                    <td>
                        <a class="btn btn-xs" ng-click="open(x.imageUrl);">
                            <img src="file/draw/{{x.optimizedImageUrl}}/" class="img-thumbnail"
                                 style="height: 40px; width: 40px;">
                        </a> {{ x.firstName}} {{ x.lastName}}( {{getCategory(x.type)}} )
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
        <h4><b>დოკუმენტები</b></h4>
        <hr>
        <table class="table table-striped">
            <tr>
                <th>#</th>
                <th>ტიპი</th>
                <th>ფაილი</th>
            </tr>
            <tr ng-repeat="d in documents">
                <td>{{$index + 1}}</td>
                <td>{{ d.type.name}}</td>
                <td><a class="btn btn-xs" ng-click="open(d.name);">{{d.name}}</a></td>
            </tr>
        </table>
        <div class="form-group"><br/></div>
    </div>
    <div class="col-sm-12" ng-show="history.length > 0">
        <h4><b>ისტორია</b></h4>
        <hr>
        <table class="table table-striped">
            <tr>
                <th>#</th>
                <th>გამგზავნი</th>
                <th>მიმღები</th>
                <th>სტატუსი</th>
                <th>შენიშვნა</th>
                <th>თარიღი</th>
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
</body>
</html>