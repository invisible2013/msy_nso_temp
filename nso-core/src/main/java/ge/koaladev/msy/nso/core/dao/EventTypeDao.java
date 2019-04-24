/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dao;

import ge.koaladev.msy.nso.database.model.AbstractDAO;
import ge.koaladev.msy.nso.database.model.EventType;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import org.springframework.stereotype.Repository;

/**
 * @author nl
 */
@Repository
public class EventTypeDao extends AbstractDAO<EventType> {

    @PersistenceContext(unitName = "nso")
    private EntityManager entityManager;

    @Override
    public EntityManager getEntityManager() {
        return entityManager;
    }

    public List<EventType> getEventTypeByApplicationTypeId(int applicationTypeId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(EventType.class.getSimpleName()).append(" e Where 1 = 1 ");
        if (applicationTypeId > 0) {
            q.append(" and e.applicationTypeId =").append(applicationTypeId);
        }
        TypedQuery<EventType> query = entityManager.createQuery(q.toString(), EventType.class);
        return query.getResultList();
    }

}
