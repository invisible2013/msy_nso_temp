/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.database.model;

import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 *
 * @author nino
 */
@Entity
@Table(name = "calendar")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Calendars.findAll", query = "SELECT e FROM Calendars e")})
public class Calendars implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @TableGenerator(name = "id_generator", table = "id_generator", valueColumnName = "value", pkColumnName = "pk_column_name", pkColumnValue = "calendar_max_id", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.TABLE, generator = "id_generator")
    private Integer id;


    @Column(name = "name")
    private String name;

    @Column(name = "location")
    private String location;

    @JoinColumn(name = "sender_user_id")
    @OneToOne
    private Users senderUser;

    @JoinColumn(name = "status_id")
    @OneToOne
    private CalendarStatus status;
    @JoinColumn(name = "calendar_type_id")
    @OneToOne
    private CalendarType calendarType;
    @Column(name = "create_date")
    @Temporal(TemporalType.DATE)
    private Date createDate;
    @Column(name = "event_date")
    @Temporal(TemporalType.DATE)
    private Date eventDate;

    @Column(name = "end_date")
    @Temporal(TemporalType.DATE)
    private Date endDate;

    @Column(name = "first")
    private Double first;

    @Column(name = "second")
    private Double second;

    @Column(name = "third")
    private Double third;

    @Column(name = "fourth")
    private Double fourth;

    @Column(name = "participant")
    private String participant;

    @Column(name = "note")
    private String note;


    public Calendars() {
    }

    public Calendars(Integer id) {
        this.id = id;
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

    public Users getSenderUser() {
        return senderUser;
    }

    public void setSenderUser(Users senderUser) {
        this.senderUser = senderUser;
    }

    public CalendarStatus getStatus() {
        return status;
    }

    public void setStatus(CalendarStatus status) {
        this.status = status;
    }

    public CalendarType getCalendarType() {
        return calendarType;
    }

    public void setCalendarType(CalendarType calendarType) {
        this.calendarType = calendarType;
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

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getParticipant() {
        return participant;
    }

    public void setParticipant(String participant) {
        this.participant = participant;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Calendars)) {
            return false;
        }
        Calendars other = (Calendars) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "Calendars[ id=" + id + " ]";
    }

}
