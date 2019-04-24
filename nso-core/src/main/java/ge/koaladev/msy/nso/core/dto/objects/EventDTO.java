package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ge.koaladev.msy.nso.core.misc.JsonDateSerializeSupport;
import ge.koaladev.msy.nso.database.model.Event;
import ge.koaladev.msy.nso.database.model.EventDecision;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author mindia
 */
public class EventDTO {

    private Integer id;
    private String key;
    private String eventName;
    private String idNumber;
    private String registrationNumber;
    private String letterNumber;
    private Integer senderUserId;
    private Integer dispatcherId;
    private Integer supervisorId;
    private Integer lastStatusId;
    private Integer lastUserId;
    private Integer lastSenderUserId;
    private Integer iteration;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date lastStatusDate;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date createDate;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date lastUpdateDate;
    private String eventDescription;
    private String purpose;
    private String expectedResult;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date startDate;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date endDate;
    private Double budget;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date reportDeliveryDate;
    private String responsiblePerson;
    private String responsiblePersonPosition;
    private EventTypeDTO eventType;
    private Integer eventTypeId;
    private EventDecision eventDecision;
    private UserDTO senderUser;
    private EventStatusDTO lastStatus;
    private ApplicationTypeDTO applicationType;
    private Double realAmount;
    private Boolean blocked;

    private List<EventPersonDTO> persons;
    private List<EventDocumentDTO> documents;

    public static int EVENT_STATUS_INCOMPLETE = 1;
    public static int EVENT_STATUS_NEW = 2;
    public static int EVENT_STATUS_SUPERVISOR_CHECK = 3;
    public static int EVENT_STATUS_RETURNED = 4;
    public static int EVENT_STATUS_SUPERVISOR_APPROVE = 5;
    public static int EVENT_STATUS_APPROVED = 6;
    public static int EVENT_STATUS_ACCOUNTED = 7;
    public static int EVENT_STATUS_CLOSED = 8;
    public static int EVENT_STATUS_CORRECTED = 9;
    public static int EVENT_STATUS_SEND_ACCOUNTANT = 10;
    public static int EVENT_STATUS_ACCOUNTANT_APPROVE = 11;
    public static int EVENT_STATUS_PROCESSING = 12;
    public static int EVENT_STATUS_REGISTERED = 13;
    public static int EVENT_STATUS_SUPERVISOR_REJECT = 14;
    public static int EVENT_STATUS_MANAGER_REJECT = 15;

    public static int EVENT_DESICION_OK = 1;
    public static int EVENT_DESICION_NO = 2;

    public static int EVENT_ITERATION_ONE = 1;
    public static int EVENT_ITERATION_TWO = 2;

    public static int EVENT_DOCUMENT_OTHER = 6;
    public static int EVENT_DOCUMENT_FINANCIAL_REPORT = 7;
    public static int EVENT_DOCUMENT_TECHNICAL_REPORT = 5;

    public static int APPLICATION_TYPE_EVENT = 1;
    public static int APPLICATION_TYPE_OTHER = 2;


    public static EventDTO parse(Event event, boolean persons, boolean documents) {

        EventDTO requestDTO = new EventDTO();
        requestDTO.setId(event.getId());
        requestDTO.setKey(event.getKey());
        requestDTO.setIdNumber(event.getIdNumber());
        requestDTO.setRegistrationNumber(event.getRegistrationNumber());
        requestDTO.setLetterNumber(event.getLetterNumber());
        requestDTO.setEventName(event.getEventName());
        requestDTO.setEventDescription(event.getEventDescription());
        requestDTO.setPurpose(event.getPurpose());
        requestDTO.setExpectedResult(event.getExpectedResult());
        requestDTO.setResponsiblePerson(event.getResponsiblePerson());
        requestDTO.setResponsiblePersonPosition(event.getResponsiblePersonPosition());
        requestDTO.setStartDate(event.getStartDate());
        requestDTO.setCreateDate(event.getCreateDate());
        requestDTO.setLastStatusDate(event.getLastStatusDate());
        requestDTO.setLastUpdateDate(event.getLastUpdateDate());
        requestDTO.setEndDate(event.getEndDate());
        requestDTO.setReportDeliveryDate(event.getReportDeliveryDate());
        requestDTO.setBudget(event.getBudget());
        requestDTO.setEventTypeId(event.getEventType());
        requestDTO.setSenderUser(UserDTO.parse(event.getSenderUser(), true));
        requestDTO.setLastStatus(EventStatusDTO.parse(event.getLastStatus()));
        requestDTO.setLastUserId(event.getLastUserId());
        requestDTO.setLastSenderUserId(event.getLastSenderUserId());
        requestDTO.setIteration(event.getIteration());
        requestDTO.setDispatcherId(event.getDispatcherId());
        requestDTO.setSupervisorId(event.getSupervisorId());
        requestDTO.setEventDecision(event.getEventDecision());
        requestDTO.setRealAmount(event.getRealAmount());
        requestDTO.setApplicationType(ApplicationTypeDTO.parse(event.getApplicationType()));

        if (persons && event.getPersons() != null) {
            requestDTO.setPersons(EventPersonDTO.parseToList(event.getPersons()));
        }
        if (documents && event.getDocuments() != null) {
            requestDTO.setDocuments(EventDocumentDTO.parseToList(event.getDocuments()));
        }
        return requestDTO;
    }

    public static List<EventDTO> parseToList(List<Event> events, boolean persons, boolean documents) {

        List<EventDTO> dTOs = new ArrayList<>();
        events.stream().forEach((n) -> {
            dTOs.add(EventDTO.parse(n, persons, documents));
        });
        return dTOs;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public EventStatusDTO getLastStatus() {
        return lastStatus;
    }

    public void setLastStatus(EventStatusDTO lastStatus) {
        this.lastStatus = lastStatus;
    }

    public Integer getSenderUserId() {
        return senderUserId;
    }

    public void setSenderUserId(Integer senderUserId) {
        this.senderUserId = senderUserId;
    }

    public Integer getDispatcherId() {
        return dispatcherId;
    }

    public void setDispatcherId(Integer dispatcherId) {
        this.dispatcherId = dispatcherId;
    }

    public Integer getSupervisorId() {
        return supervisorId;
    }

    public void setSupervisorId(Integer supervisorId) {
        this.supervisorId = supervisorId;
    }

    public Integer getLastStatusId() {
        return lastStatusId;
    }

    public void setLastStatusId(Integer lastStatusId) {
        this.lastStatusId = lastStatusId;
    }

    public Date getLastStatusDate() {
        return lastStatusDate;
    }

    public void setLastStatusDate(Date lastStatusDate) {
        this.lastStatusDate = lastStatusDate;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Date getLastUpdateDate() {
        return lastUpdateDate;
    }

    public void setLastUpdateDate(Date lastUpdateDate) {
        this.lastUpdateDate = lastUpdateDate;
    }

    public String getEventDescription() {
        return eventDescription;
    }

    public void setEventDescription(String eventDescription) {
        this.eventDescription = eventDescription;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public String getExpectedResult() {
        return expectedResult;
    }

    public void setExpectedResult(String expectedResult) {
        this.expectedResult = expectedResult;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public Double getBudget() {
        return budget;
    }

    public void setBudget(Double budget) {
        this.budget = budget;
    }

    public Date getReportDeliveryDate() {
        return reportDeliveryDate;
    }

    public void setReportDeliveryDate(Date reportDeliveryDate) {
        this.reportDeliveryDate = reportDeliveryDate;
    }

    public String getResponsiblePerson() {
        return responsiblePerson;
    }

    public void setResponsiblePerson(String responsiblePerson) {
        this.responsiblePerson = responsiblePerson;
    }

    public String getResponsiblePersonPosition() {
        return responsiblePersonPosition;
    }

    public void setResponsiblePersonPosition(String responsiblePersonPosition) {
        this.responsiblePersonPosition = responsiblePersonPosition;
    }

    public EventTypeDTO getEventType() {
        return eventType;
    }

    public void setEventType(EventTypeDTO eventType) {
        this.eventType = eventType;
    }

    public List<EventPersonDTO> getPersons() {
        return persons;
    }

    public void setPersons(List<EventPersonDTO> persons) {
        this.persons = persons;
    }

    public List<EventDocumentDTO> getDocuments() {
        return documents;
    }

    public void setDocuments(List<EventDocumentDTO> documents) {
        this.documents = documents;
    }

    public UserDTO getSenderUser() {
        return senderUser;
    }

    public void setSenderUser(UserDTO senderUser) {
        this.senderUser = senderUser;
    }

    public EventDecision getEventDecision() {
        return eventDecision;
    }

    public void setEventDecision(EventDecision eventDecision) {
        this.eventDecision = eventDecision;
    }

    public ApplicationTypeDTO getApplicationType() {
        return applicationType;
    }

    public void setApplicationType(ApplicationTypeDTO applicationType) {
        this.applicationType = applicationType;
    }

    public Double getRealAmount() {
        return realAmount;
    }

    public void setRealAmount(Double realAmount) {
        this.realAmount = realAmount;
    }

    public Integer getEventTypeId() {
        return eventTypeId;
    }

    public void setEventTypeId(Integer eventTypeId) {
        this.eventTypeId = eventTypeId;
    }

    public Integer getLastUserId() {
        return lastUserId;
    }

    public void setLastUserId(Integer lastUserId) {
        this.lastUserId = lastUserId;
    }

    public Integer getIteration() {
        return iteration;
    }

    public void setIteration(Integer iteration) {
        this.iteration = iteration;
    }

    public Integer getLastSenderUserId() {
        return lastSenderUserId;
    }

    public void setLastSenderUserId(Integer lastSenderUserId) {
        this.lastSenderUserId = lastSenderUserId;
    }

    public String getIdNumber() {
        return idNumber;
    }

    public void setIdNumber(String idNumber) {
        this.idNumber = idNumber;
    }

    public String getRegistrationNumber() {
        return registrationNumber;
    }

    public void setRegistrationNumber(String registrationNumber) {
        this.registrationNumber = registrationNumber;
    }

    public String getLetterNumber() {
        return letterNumber;
    }

    public void setLetterNumber(String letterNumber) {
        this.letterNumber = letterNumber;
    }

    public Boolean getBlocked() {
        return blocked;
    }

    public void setBlocked(Boolean blocked) {
        this.blocked = blocked;
    }
}
