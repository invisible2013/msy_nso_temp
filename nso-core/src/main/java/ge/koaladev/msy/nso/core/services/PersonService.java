/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.services;

import ge.koaladev.msy.nso.core.dao.PersonDAO;
import ge.koaladev.msy.nso.core.dto.admin.FindPersonRequest;
import ge.koaladev.msy.nso.core.dto.objects.PersonDTO;
import ge.koaladev.msy.nso.core.services.file.FileItem;
import ge.koaladev.msy.nso.core.services.file.FileService;
import ge.koaladev.msy.nso.database.model.Person;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * @author mindia
 */
@Service
public class PersonService {

    @Autowired
    private PersonDAO personDAO;

    @Autowired
    private FileService fileService;

    @Transactional
    public PersonDTO addPerson(PersonDTO person) {

        Person p;
        if (person.getId() == null) {
            p = new Person();
        } else {
            p = personDAO.find(Person.class, person.getId());
        }
        p.setAddress(person.getAddress());
        p.setBirthDate(person.getBirthDate());
        p.setFirstName(person.getFirstName());
        p.setLastName(person.getLastName());
        p.setPersonalNumber(person.getPersonalNumber());
        p.setTypeId(person.getTypeId());

        p = p.getId() == null ? personDAO.create(p) : personDAO.update(p);

        return PersonDTO.parse(p);
    }

    @Transactional
    public PersonDTO addPersonImage(Integer personId, MultipartFile file) {

        Person p = personDAO.find(Person.class, personId);
        FileItem fileItem = fileService.saveFile(file, p.getPersonalNumber().trim(), true, true);

        //delete old files
        deletePersonFiles(p.getId());

        p.setImageUrl(fileItem.getName());
        p.setImageThumbnailUrl(fileItem.getThumbnail());

        p = personDAO.update(p);

        return PersonDTO.parse(p);
    }


    public void deletePersonFiles(int personId) {
        Person person = personDAO.find(Person.class, personId);
        fileService.deleteFile(person.getImageUrl());
        fileService.deleteFile(person.getImageThumbnailUrl());
    }


    @Transactional
    public PersonDTO findPersonByPersonalNumber(FindPersonRequest findPersonRequest) {
        Person p = personDAO.findPersonByPersonalNumber(findPersonRequest.getPersonalNumber());
        return PersonDTO.parse(p == null ? new Person() : p);
    }

    @Transactional
    public List<PersonDTO> getPersonsByTypeId(int typeId, int userId, Integer start, Integer limit, String fullText) {
        return PersonDTO.parseToList(personDAO.getPersonsByTypeId(typeId, userId, start, limit, fullText));
    }

    @Transactional
    public List<PersonDTO> getPersons(int userId) {
        return PersonDTO.parseToList(personDAO.getPersons(userId));
    }

}
