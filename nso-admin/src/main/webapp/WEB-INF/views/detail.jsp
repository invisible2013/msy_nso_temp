<%@page contentType="text/html" pageEncoding="UTF-8" %>
<script>
    function printDetail() {
        var printContents = document.getElementById('printInformation').innerHTML;
        var originalContents = document.body.innerHTML;
        document.body.innerHTML = printContents;
        window.print();
        document.body.innerHTML = originalContents;
    }
    function hideModal(){
        window.location.reload();
    }
</script>
<div class="modal fade bs-example-modal-lg" id="detailModal" tabindex="-1" role="dialog"
     aria-labelledby="detailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" onclick="hideModal();" aria-label="Close"><span
                        aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="detailModalLabel">დეტალური ინფორმაცია ({{detailInfo.eventName}})</h4>
                <button data-toggle="tooltip" title="ბეჭდვა" class="btn btn-xs text-right"
                       onclick="printDetail();">
                <span class="glyphicon glyphicon-print"></span>
                </button>
            </div>
            <div class="modal-body">
                <div class="row">
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
                            <h5>მონაწილეები</h5>
                            <hr>
                            <table class="table table-striped">
                                <tr>
                                    <th>მონაწილე</th>
                                    <th>პირ. N</th>
                                    <th>დ/წ</th>
                                    <th>კლუბი</th>
                                    <th>პოზიცია</th>
                                    <th>წ/კ</th>
                                </tr>
                                <tr ng-repeat="x in persons">
                                    <td>
                                        <a class="btn btn-xs" ng-click="open(x.imageUrl);">
                                            <img src="file/draw/{{x.imageUrl}}/" class="img-thumbnail"
                                                 style="height: 40px;" height="40">
                                        </a> {{ x.firstName}} {{ x.lastName}}( {{getCategory(x.type)}} )
                                    </td>
                                    </td>
                                    <td>{{ x.personalNumber}}</td>
                                    <td>{{ x.birthDate| date:'dd/MM/yyyy'}}</td>
                                    <td>{{ x.club}}</td>
                                    <td>{{ x.position}}</td>
                                    <td>{{ x.weightCategory}}</td>
                                </tr>
                            </table>
                            <div class="form-group"><br/></div>
                        </div>
                    </div>
                    <div class="col-md-8" ng-show="documents.length > 0">
                        <h5>დოკუმენტები</h5>
                        <hr>
                        <table class="table table-striped">
                            <tr>
                                <th>ტიპი</th>
                                <th>ფაილი</th>
                            </tr>
                            <tr ng-repeat="d in documents">
                                <td>{{ d.type.name}}</td>
                                <td><a class="btn btn-xs" ng-click="open(d.name);">{{d.name}}</a></td>
                            </tr>
                        </table>
                        <div class="form-group"><br/></div>
                    </div>
                    <div class="col-sm-12" ng-show="history.length > 0">
                        <h5>ისტორია</h5>
                        <hr>
                        <table class="table table-striped">
                            <tr>
                                <th></th>
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
            </div>
            <div class="modal-footer">
            </div>
        </div>
    </div>
</div>