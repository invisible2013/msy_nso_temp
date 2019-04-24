/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dao;

import ge.koaladev.msy.nso.database.misc.ParamValuePair;
import ge.koaladev.msy.nso.database.model.AbstractDAO;
import ge.koaladev.msy.nso.database.model.Person;
import ge.koaladev.msy.nso.database.model.PersonType;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.stereotype.Repository;

/**
 * @author mindia
 */
@Repository
public class PersonDAO extends AbstractDAO<PersonType> {

    @PersistenceContext(unitName = "nso")
    private EntityManager entityManager;

    @Override
    public EntityManager getEntityManager() {
        return entityManager;
    }

    public Person findPersonByPersonalNumber(String PersonNumber) {
        List<ParamValuePair> paramValuePairs = new ArrayList<>();
        ParamValuePair paramValuePair = new ParamValuePair("personalNumber", PersonNumber);
        paramValuePairs.add(paramValuePair);
        List<Person> persons = getAllByParamValue(Person.class, paramValuePairs);
        return persons == null || persons.size() == 0 ? null : persons.get(0);
    }

    public List<Person> getPersonsByTypeId(int typeId, int userId, Integer start, Integer limit, String fullText) {
        List<ParamValuePair> paramValuePairs = new ArrayList<>();
        ParamValuePair paramValuePair = new ParamValuePair("typeId", typeId);
        paramValuePairs.add(paramValuePair);
        if (userId > 0) {
            ParamValuePair paramValuePair2 = new ParamValuePair("userId", userId);
            paramValuePairs.add(paramValuePair2);
        }
        List<Person> persons = getAllByParamValueByLimits(Person.class, paramValuePairs, start, limit, fullText);
        return persons;
    }

    public List<Person> getPersons(int userId) {
        List<ParamValuePair> paramValuePairs = new ArrayList<>();
        if (userId > 0) {
            ParamValuePair paramValuePair2 = new ParamValuePair("userId", userId);
            paramValuePairs.add(paramValuePair2);
        }
        List<Person> persons = getAllByParamValueByLimits(Person.class, paramValuePairs, null, null, null);
        return persons;
    }
}
