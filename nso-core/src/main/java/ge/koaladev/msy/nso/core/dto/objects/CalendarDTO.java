package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ge.koaladev.msy.nso.core.misc.JsonDateSerializeSupport;
import ge.koaladev.msy.nso.database.model.CalendarType;
import ge.koaladev.msy.nso.database.model.Calendars;
import ge.koaladev.msy.nso.database.model.CalendarStatus;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author nino
 */
public class CalendarDTO {

    private Integer id;
    private String name;
    private String location;
    private String note;
    private String participant;
    private Integer senderUserId;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date createDate;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date eventDate;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date endDate;
    private UserDTO senderUser;
    private Double first;
    private Double second;
    private Double third;
    private Double fourth;
    private CalendarStatus calendarStatus;
    private CalendarType calendarType;
    private List<CalendarPersonDTO> calendarPersons;

    public static Integer STATUS_NEW = 1;
    public static Integer STATUS_BLOCKED = 2;
    public static Integer STATUS_SENT = 3;
    public static Integer STATUS_CORRECTED = 4;


    public static CalendarDTO parse(Calendars item) {

        CalendarDTO requestDTO = new CalendarDTO();
        requestDTO.setId(item.getId());
        requestDTO.setName(item.getName());
        requestDTO.setLocation(item.getLocation());
        requestDTO.setEventDate(item.getEventDate());
        requestDTO.setEndDate(item.getEndDate());
        requestDTO.setFirst(item.getFirst());
        requestDTO.setSecond(item.getSecond());
        requestDTO.setThird(item.getThird());
        requestDTO.setFourth(item.getFourth());
        requestDTO.setCreateDate(item.getCreateDate());
        requestDTO.setCalendarStatus(item.getStatus());
        requestDTO.setCalendarType(item.getCalendarType());
        requestDTO.setParticipant(item.getParticipant());
        requestDTO.setNote(item.getNote());
        requestDTO.setSenderUser(UserDTO.parse(item.getSenderUser(), true));

        return requestDTO;
    }

    public static List<CalendarDTO> parseToList(List<Calendars> items) {

        List<CalendarDTO> dTOs = new ArrayList<>();
        items.stream().forEach((n) -> {
            dTOs.add(CalendarDTO.parse(n));
        });
        return dTOs;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getSenderUserId() {
        return senderUserId;
    }

    public void setSenderUserId(Integer senderUserId) {
        this.senderUserId = senderUserId;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Date getEventDate() {
        return eventDate;
    }

    public void setEventDate(Date eventDate) {
        this.eventDate = eventDate;
    }

    public UserDTO getSenderUser() {
        return senderUser;
    }

    public void setSenderUser(UserDTO senderUser) {
        this.senderUser = senderUser;
    }

    public Double getFirst() {
        return first;
    }

    public void setFirst(Double first) {
        this.first = first;
    }

    public Double getSecond() {
        return second;
    }

    public void setSecond(Double second) {
        this.second = second;
    }

    public Double getThird() {
        return third;
    }

    public void setThird(Double third) {
        this.third = third;
    }

    public Double getFourth() {
        return fourth;
    }

    public void setFourth(Double fourth) {
        this.fourth = fourth;
    }

    public CalendarStatus getCalendarStatus() {
        return calendarStatus;
    }

    public void setCalendarStatus(CalendarStatus calendarStatus) {
        this.calendarStatus = calendarStatus;
    }

    public CalendarType getCalendarType() {
        return calendarType;
    }

    public void setCalendarType(CalendarType calendarType) {
        this.calendarType = calendarType;
    }

    public List<CalendarPersonDTO> getCalendarPersons() {
        return calendarPersons;
    }

    public void setCalendarPersons(List<CalendarPersonDTO> calendarPersons) {
        this.calendarPersons = calendarPersons;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getParticipant() {
        return participant;
    }

    public void setParticipant(String participant) {
        this.participant = participant;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
}
