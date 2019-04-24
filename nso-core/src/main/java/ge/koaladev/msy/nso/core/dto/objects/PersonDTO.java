/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dto.objects;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import ge.koaladev.msy.nso.core.misc.JsonDateSerializeSupport;
import ge.koaladev.msy.nso.database.model.Person;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author mindia
 */
public class PersonDTO {

    private Integer id;
    private Integer typeId;
    private Integer genderId;
    private Integer userId;
    private String firstName;
    private String lastName;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date birthDate;
    private String imageUrl;
    private String imageThumbnailUrl;
    private String optimizedImageUrl;
    private String personalNumber;
    private String address;
    private String weightCategory;
    private String position;
    private String category;
    private String club;
    private String city;
    private String trainer;
    @JsonSerialize(using = JsonDateSerializeSupport.class)
    private Date createDate;

    public static PersonDTO parse(Person person) {

        PersonDTO personDTO = new PersonDTO();
        personDTO.setId(person.getId());
        personDTO.setFirstName(person.getFirstName());
        personDTO.setLastName(person.getLastName());
        personDTO.setBirthDate(person.getBirthDate());
        personDTO.setImageUrl(person.getImageUrl());
        personDTO.setImageThumbnailUrl(person.getImageThumbnailUrl());
        personDTO.setOptimizedImageUrl(person.getImageThumbnailUrl() != null ? person.getImageThumbnailUrl() : person.getImageUrl());
        personDTO.setPersonalNumber(person.getPersonalNumber());
        personDTO.setAddress(person.getAddress());
        personDTO.setWeightCategory(person.getWeightCategory());
        personDTO.setPosition(person.getPosition());
        personDTO.setCategory(person.getCategory());
        personDTO.setClub(person.getClub());
        personDTO.setCity(person.getCity());
        personDTO.setTrainer(person.getTrainer());
        personDTO.setTypeId(person.getTypeId());
        personDTO.setUserId(person.getUserId());
        personDTO.setGenderId(person.getGenderId());
        personDTO.setCreateDate(person.getCreateDate());
        return personDTO;
    }

    public static List<PersonDTO> parseToList(List<Person> persons) {

        List<PersonDTO> dTOs = new ArrayList<>();
        persons.stream().forEach((p) -> {
            dTOs.add(PersonDTO.parse(p));
        });

        return dTOs;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
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

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getPersonalNumber() {
        return personalNumber;
    }

    public void setPersonalNumber(String personalNumber) {
        this.personalNumber = personalNumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getWeightCategory() {
        return weightCategory;
    }

    public void setWeightCategory(String weightCategory) {
        this.weightCategory = weightCategory;
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

    public Integer getTypeId() {
        return typeId;
    }

    public void setTypeId(Integer typeId) {
        this.typeId = typeId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
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

    public Integer getGenderId() {
        return genderId;
    }

    public void setGenderId(Integer genderId) {
        this.genderId = genderId;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }
}


