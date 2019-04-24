<%@page contentType="text/html" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="resources/css/bootstrap-datepicker.css"/>
<%@include file="header2.jsp" %>


<script>
    var app = angular.module("app", []);
    app.controller("addCalendarCtrl", function ($scope, $http, $filter, $location) {
        var absUrl = $location.absUrl();
        $scope.report = {};
        $scope.currentReportId = 0;
        $scope.years=[];
        var currentYear = new Date().getFullYear();
        for (var a = 2016; a <= currentYear; a++) {
            $scope.years.push({id: a, name: a});
        }

        if (absUrl.split("?")[1]) {
            $scope.currentReportId = absUrl.split("?")[1].split("=")[1];
        }

        $scope.types = [];
        $scope.persons = [];
        $scope.documents = [];
        $scope.documentTypes = [];

        if ($scope.currentReportId > 0) {
            function getEvent(res) {
                $scope.report = res.data;
                console.log(res.data);
            }

            ajaxCall($http, "soas/get-annual-report-item", angular.toJson({'id': $scope.currentReportId}), getEvent);

        } else {
            $scope.report = {'id': $scope.currentReportId};
        }

        function isEmptyValue(variable) {
            return variable == undefined || variable == null || variable.length == 0;
        };


        $scope.addAnnualReport = function () {

            if (isEmptyValue($scope.report.introduction)) {
                Modal.info('Enter Intorduction');
                return;
            }
            if (isEmptyValue($scope.report.result)) {
                Modal.info('Enter Results');
                return;
            }

            ajaxCall($http, "soas/add-annual-report", angular.toJson($scope.report), function (res) {
                window.location = "soas";
            });
        };


        $scope.open = function (name) {
            if (name.indexOf('.pdf') >= 0) {
                window.open('file/draw/' + name + '/');
            } else {
                window.open('file/download/' + name + '/');
            }
        };


    });

</script>

<div ng-controller="addCalendarCtrl" id="eventControllerId">
    <!-- Main Content -->
    <section class="content">
        <div class="block-header">
            <div class="row">
                <div class="col-lg-7 col-md-6 col-sm-12">
                    <h2>Annual report
                        <small>Add Annual report</small>
                    </h2>
                </div>
                <div class="col-lg-5 col-md-6 col-sm-12">
                    <ul class="breadcrumb float-md-right">
                        <li class="breadcrumb-item"><a href="home"><i class="zmdi zmdi-home"></i> Nso</a></li>
                        <li class="breadcrumb-item active">New Report</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="container-fluid">
            <div class="row clearfix">
                <div class="col-lg-12">
                    <div class="card">
                        <div class="body">

                            <div>
                                <form class="form-horizontal col-md-10">
                                    <div class="form-group col-sm-10">
                                        <label>Year</label>
                                        <select class="form-control input-sm" ng-model="report.year">
                                                <option ng-repeat="is in years" value="{{is.id}}">{{is.name}}
                                            </option>
                                        </select>
                                    </div>
                                    <div class="form-group col-sm-10">
                                        <label>Introduction</label>
                                        <textarea class="form-control input-sm" ng-model="report.introduction"
                                                  placeholder="მიმდინარე წელს დასახული მიზნები და ამოცანები;&#10; საქმიანობის ძირითადი მიმართულებები"
                                                  rows="2"></textarea>
                                    </div>
                                    <div class="form-group col-sm-10">
                                        <label>Results (for last 4 years, dynamics)</label>
                                        <textarea class="form-control input-sm" ng-model="report.result"
                                                  placeholder="მიღწეული წარმატება, საუკეთესო შედეგი;&#10;წარმატების პერსპექტივა, ასაკობრივი ნაკრებები."
                                                  rows="2"></textarea>
                                    </div>
                                    <div class="form-group col-sm-10">
                                        <label>Good governance</label>
                                        <textarea class="form-control input-sm" ng-model="report.governance"
                                                  placeholder="წესდების სრულყოფაზე გაწეული სამუშაო;&#10;სტრუქტურული მოწყობა, მენეჯმენტი;&#10;სტატისტიკის წარმოება, მუდმივი განახლება;"
                                                  rows="3"></textarea>
                                    </div>
                                    <div class="form-group col-sm-10">
                                        <label>Increase of qualification</label>
                                        <textarea class="form-control input-sm" ng-model="report.qualification"
                                                  placeholder="ორგანიზაციაში მომუშავე პერსონალის გადამზადება;&#10;მწვრთნელთა და მსაჯთა სერტიფიცირება/ლიცენზირება."
                                                  rows="2"></textarea>
                                    </div>
                                    <div class="form-group col-sm-10">
                                        <label>Promotion</label>
                                        <textarea class="form-control input-sm" ng-model="report.popularisation"
                                                  placeholder="რეკლამა, პიარი;&#10;ოფიციალური ვებ-გვერდი, სოციალური ქსელი;&#10;პრომო ღონისძიებები."
                                                  rows="3"></textarea>
                                    </div>
                                    <div class="form-group col-sm-10">
                                        <label>Fight against doping, match-fixing, manipulations, violance an discrimination in sport</label>
                                        <textarea class="form-control input-sm" ng-model="report.fight"
                                                  placeholder="საინფორმაციო კამპანია;&#10;ტრენინგი, სემინარი."
                                                  rows="2"></textarea>
                                    </div>
                                    <div class="form-group col-sm-10">
                                        <label>Gender issues</label>
                                        <textarea class="form-control input-sm" ng-model="report.genderIssue"
                                                  placeholder="გენდერული ბალანსი;&#10;ქალთა ჩართულობა;&#10;გენდერული თანასწორობა."
                                                  rows="3"></textarea>
                                    </div>
                                    <div class="form-group col-sm-10">
                                        <label>Alternative funding</label>
                                        <textarea class="form-control input-sm" ng-model="report.alternative"
                                                  placeholder="სპონსორები;&#10;დონორი ორგანიზაციები;&#10;სხვა (არასახელმწიფო) შემოსავლები."
                                                  rows="3"></textarea>
                                    </div>
                                    <div class="form-group col-sm-10">
                                        <label>Grassroots </label>
                                        <textarea class="form-control input-sm" ng-model="report.mass"
                                                  placeholder="მასობრივი სპორტული ღონისძიებები;&#10;სპორტსმენთა ჩართულობის დინამიკა (სულ მცირე ბოლო 2 წელი)."
                                                  rows="2"></textarea>
                                    </div>
                                    <div class="form-group col-sm-10">
                                        <label>Conclusion</label>
                                        <textarea class="form-control input-sm" ng-model="report.conclusion"
                                                  placeholder="შემაჯამებელი ანალიზი."
                                                  rows="2"></textarea>
                                    </div>

                                    <div class="form-group col-sm-10">
                                        <br/><br/>
                                        <button type="button" class="btn btn-primary btn-xs"
                                                ng-click="addAnnualReport()">
                                            Save and close
                                        </button>
                                    </div>
                                    <div class="form-group"><br/><br/></div>
                                </form>
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

