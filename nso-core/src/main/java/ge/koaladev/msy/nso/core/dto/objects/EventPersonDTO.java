/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ge.koaladev.msy.nso.core.misc.JsonDateSerializeSupport;
import ge.koaladev.msy.nso.database.model.EventPerson;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author mindia
 */
public class EventPersonDTO {

    private Integer id;
    private Integer personId;
    private Integer type;
    private String firstName;
    private String lastName;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date birthDate;
    private String address;
    private String imageUrl;
    private String imageThumbnailUrl;
    private String optimizedImageUrl;
    private String weightCategory;
    private String personalNumber;
    private String position;
    private String category;
    private Integer eventId;
    private String club;
    private String city;
    private String trainer;

    public static EventPersonDTO parse(EventPerson eventPerson) {

        EventPersonDTO ep = new EventPersonDTO();
        ep.setId(eventPerson.getId());
        ep.setEventId(eventPerson.getEventId());
        ep.setType(eventPerson.getType());
        ep.setPersonId(eventPerson.getPerson().getId());
        ep.setFirstName(eventPerson.getPerson().getFirstName());
        ep.setLastName(eventPerson.getPerson().getLastName());
        ep.setBirthDate(eventPerson.getPerson().getBirthDate());
        ep.setAddress(eventPerson.getPerson().getAddress());
        ep.setImageUrl(eventPerson.getPerson().getImageUrl());
        ep.setImageThumbnailUrl(eventPerson.getPerson().getImageThumbnailUrl());
        ep.setOptimizedImageUrl(eventPerson.getPerson().getImageThumbnailUrl() != null ? eventPerson.getPerson().getImageThumbnailUrl() : eventPerson.getPerson().getImageUrl());
        ep.setWeightCategory(eventPerson.getPerson().getWeightCategory());
        ep.setPersonalNumber(eventPerson.getPerson().getPersonalNumber());
        ep.setPosition(eventPerson.getPerson().getPosition());
        ep.setCategory(eventPerson.getPerson().getCategory());
        ep.setClub(eventPerson.getPerson().getClub());
        ep.setCity(eventPerson.getPerson().getCity());
        ep.setTrainer(eventPerson.getPerson().getTrainer());

        return ep;

    }

    public static List<EventPersonDTO> parseToList(List<EventPerson> eps) {

        List<EventPersonDTO> dTOs = new ArrayList<>();
        eps.stream().forEach((n) -> {
            dTOs.add(EventPersonDTO.parse(n));
        });

        return dTOs;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public Date getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getWeightCategory() {
        return weightCategory;
    }

    public void setWeightCategory(String weightCategory) {
        this.weightCategory = weightCategory;
    }

    public String getPersonalNumber() {
        return personalNumber;
    }

    public void setPersonalNumber(String personalNumber) {
        this.personalNumber = personalNumber;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Integer getEventId() {
        return eventId;
    }

    public void setEventId(Integer eventId) {
        this.eventId = eventId;
    }

    public String getClub() {
        return club;
    }

    public void setClub(String club) {
        this.club = club;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getTrainer() {
        return trainer;
    }

    public void setTrainer(String trainer) {
        this.trainer = trainer;
    }

    public Integer getPersonId() {
        return personId;
    }

    public void setPersonId(Integer personId) {
        this.personId = personId;
    }

    public String getImageThumbnailUrl() {
        return imageThumbnailUrl;
    }

    public void setImageThumbnailUrl(String imageThumbnailUrl) {
        this.imageThumbnailUrl = imageThumbnailUrl;
    }

    public String getOptimizedImageUrl() {
        return optimizedImageUrl;
    }

    public void setOptimizedImageUrl(String optimizedImageUrl) {
        this.optimizedImageUrl = optimizedImageUrl;
    }
}
