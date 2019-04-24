<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@include file="header2.jsp" %>
<script>
    var app = angular.module("app", []);
    app.controller("requestCtrl", function ($scope, $http, $filter, $location) {

        $scope.documents = [];
        $scope.document = {};
        function getDocuments(res) {
            $scope.documents = res.data;
            console.log(res.data);
        }

        ajaxCall($http, "upload/get-documents", null, getDocuments);

        $scope.deleteDocument = function (id) {
            Modal.confirm("You need to confirm this operation", function () {
                if (id != undefined) {
                    ajaxCall($http, "upload/delete-document", angular.toJson({'documentId': id}), reload);
                }
            })
        };
        $scope.addDocument = function () {
            var oMyForm = new FormData();
            oMyForm.append("name", $scope.document.name);
            oMyForm.append("file", $('#documentId')[0].files[0]);
            $.ajax({
                url: 'upload/add-document',
                data: oMyForm,
                dataType: 'text',
                processData: false,
                contentType: false,
                type: 'POST',
                success: function (data) {
                    location.reload();
                },
                error: function (data, status, headers, config) {
                    location.reload();
                }
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
<div ng-controller="requestCtrl">
    <!-- Main Content -->
    <section class="content">
        <div class="block-header">
            <div class="row">
                <div class="col-lg-7 col-md-6 col-sm-12">
                    <h2>Documents
                        <small>Upload Documents</small>
                    </h2>
                </div>
                <div class="col-lg-5 col-md-6 col-sm-12">
                    <button class="btn btn-white btn-icon btn-round hidden-sm-down float-right m-l-10" type="button">
                        <i class="zmdi zmdi-plus"></i>
                    </button>
                    <ul class="breadcrumb float-md-right">
                        <li class="breadcrumb-item"><a href="home"><i class="zmdi zmdi-home"></i> Nso</a></li>
                        <li class="breadcrumb-item active">Documents</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="container-fluid">
            <div class="row clearfix">
                <div class="col-lg-12">
                    <div class="card">
                        <div class="body">

                            <form class="form-horizontal" id="documentForm">
                                <div class="form-group col-sm-6">
                                    <label>Name</label>
                                    <div>
                                        <input type="text" id="documentName" name="name" ng-model="document.name"
                                               class="form-control input-sm upload-file">
                                    </div>
                                </div>
                                <div class="form-group col-sm-6">
                                    <label>File</label>
                                    <div>
                                        <input type="file" id="documentId" name="file"
                                               class="form-control input-sm upload-file">
                                    </div>
                                </div>
                                <div class="form-group col-sm-6">
                                    <div class="col-sm-12">
                                        <!--<button type="submit" class="btn btn-primary btn-xs" >დამატება</button>-->
                                        <button type="button" class="btn btn-primary btn-xs" ng-click="addDocument()">
                                            Add Document
                                        </button>
                                    </div>
                                </div>
                            </form>
                            <div class="col-sm-6">
                                <table class="table table-striped table-hover">
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>File</th>
                                        <th></th>
                                    </tr>
                                    <tr ng-repeat="d in documents">
                                        <td>{{$index + 1}}</td>
                                        <td>{{d.name}}</td>
                                        <td><a class="btn-link text-info"
                                               ng-click="open(d.url);">{{d.url}}</a></td>
                                        <td>
                                            <button type="button" class="btn btn-icon btn-neutral btn-sm"
                                                    ng-click="deleteDocument(d.id);">
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
        </div>
    </section>

</div>

<%@include file="footer2.jsp" %>
