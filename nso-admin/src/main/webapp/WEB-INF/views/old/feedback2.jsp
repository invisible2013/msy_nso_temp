<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="header.jsp" %>
<script>
    $(document).ready(function () {
        $('[data-toggle="tooltip"]').tooltip();
    });
</script>
<script>
    var app = angular.module("app", []);
    app.controller("feedBackCtrl", function ($scope, $http, $filter, $location) {
        var absUrl = $location.absUrl();
        $scope.feedback = {};
        function isEmptyValue(variable) {
            return variable == undefined || variable == null || variable.length == 0;
        };
        $scope.sendFeedback = function () {
            if (isEmptyValue($scope.feedback.title)) {
                Modal.info('შეიყვანეთ სათაური');
                return;
            }
            if (isEmptyValue($scope.feedback.text)) {
                Modal.info('შეიყვანეთ ტექსტი');
                return;
            }
            function successFeedback(res) {
                if (res) {
                    Modal.info("Feedback გაიგზავნა წარმატებით", function () {
                        location.reload();
                    })
                }
            }

            ajaxCall($http, "feedback/send-feedback", angular.toJson($scope.feedback), successFeedback, null, "fArea");
        };

    });

</script>
<div class="col-md-12" ng-controller="feedBackCtrl" id="fArea">
    <br/>
    <form class="form-horizontal" id="feedbackForm">
        <ul class="nav nav-tabs" role="tablist">
            <li role="presentation" class="active"><a href="#home" aria-controls="home" role="tab" data-toggle="tab">ელ-ფოსტა</a>
            </li>
        </ul>

        <div class="tab-content">
            <br/>
            <div role="tabpanel" class="tab-pane active" id="home">
                <br/>
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-3">სათაური</label>
                    <div class="col-sm-9">
                        <input type="text" id="title" ng-model="feedback.title" class="form-control input-sm">
                    </div>
                </div>
                <div class="form-group col-sm-8">
                    <label class="control-label col-sm-3">ტექსტი</label>
                    <div class="col-sm-9">
                        <textarea rows="5" class="form-control" ng-model="feedback.text"></textarea>
                    </div>
                </div>
                <div class="form-group col-sm-8 text-right">
                    <div class="col-sm-12">
                        <button type="button" class="btn btn-primary btn-xs" ng-click="sendFeedback()"
                        >გაგზავნა
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<%@include file="footer.jsp" %>