package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ge.koaladev.msy.nso.core.misc.JsonDateSerializeSupport;
import ge.koaladev.msy.nso.database.model.CalendarStatus;
import ge.koaladev.msy.nso.database.model.CalendarType;
import ge.koaladev.msy.nso.database.model.Calendars;
import ge.koaladev.msy.nso.database.model.Competition;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author nino
 */
public class CompetitionDTO {

    private Integer id;
    private String name;
    private String category;
    private String location;
    private String groupQuantity;
    private String professional;
    private String discipline;
    private Integer senderUserId;
    private Integer federationId;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date createDate;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date competitionDate;
    private UserDTO senderUser;
    private UserDTO federationUser;

    private List<CompetitionPersonDTO> competitionPersons;

    public static CompetitionDTO parse(Competition item) {

        CompetitionDTO requestDTO = new CompetitionDTO();
        requestDTO.setId(item.getId());
        requestDTO.setName(item.getName());
        requestDTO.setLocation(item.getLocation());
        requestDTO.setCreateDate(item.getCreateDate());
        requestDTO.setCompetitionDate(item.getCompetitionDate());
        requestDTO.setGroupQuantity(item.getGroupQuantity());
        requestDTO.setCategory(item.getCategory());
        requestDTO.setProfessional(item.getProfessional());
        requestDTO.setDiscipline(item.getDiscipline());
        requestDTO.setFederationId(item.getFederationUser().getId());
        requestDTO.setSenderUser(UserDTO.parse(item.getSenderUser(), true));
        requestDTO.setFederationUser(UserDTO.parse(item.getFederationUser(), true));

        return requestDTO;
    }

    public static List<CompetitionDTO> parseToList(List<Competition> items) {

        List<CompetitionDTO> dTOs = new ArrayList<>();
        items.stream().forEach((n) -> {
            dTOs.add(CompetitionDTO.parse(n));
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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getGroupQuantity() {
        return groupQuantity;
    }

    public void setGroupQuantity(String groupQuantity) {
        this.groupQuantity = groupQuantity;
    }

    public String getProfessional() {
        return professional;
    }

    public void setProfessional(String professional) {
        this.professional = professional;
    }

    public Date getCompetitionDate() {
        return competitionDate;
    }

    public void setCompetitionDate(Date competitionDate) {
        this.competitionDate = competitionDate;
    }

    public UserDTO getSenderUser() {
        return senderUser;
    }

    public void setSenderUser(UserDTO senderUser) {
        this.senderUser = senderUser;
    }

    public List<CompetitionPersonDTO> getCompetitionPersons() {
        return competitionPersons;
    }

    public void setCompetitionPersons(List<CompetitionPersonDTO> competitionPersons) {
        this.competitionPersons = competitionPersons;
    }

    public String getDiscipline() {
        return discipline;
    }

    public void setDiscipline(String discipline) {
        this.discipline = discipline;
    }

    public UserDTO getFederationUser() {
        return federationUser;
    }

    public void setFederationUser(UserDTO federationUser) {
        this.federationUser = federationUser;
    }

    public Integer getFederationId() {
        return federationId;
    }

    public void setFederationId(Integer federationId) {
        this.federationId = federationId;
    }
}
