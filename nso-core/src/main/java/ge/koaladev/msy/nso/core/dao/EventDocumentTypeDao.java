/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.core.dao;

import ge.koaladev.msy.nso.database.model.AbstractDAO;
import ge.koaladev.msy.nso.database.model.EventDocumentType;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import org.springframework.stereotype.Repository;

/**
 * @author mindia
 */
@Repository
public class EventDocumentTypeDao extends AbstractDAO {

    @PersistenceContext(unitName = "nso")
    private EntityManager entityManager;

    @Override
    public EntityManager getEntityManager() {
        return entityManager;
    }

    public List<EventDocumentType> getEventDocumentTyoes(int eventTypeId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(EventDocumentType.class.getSimpleName()).append(" e Where 1=1 ");
        if (eventTypeId >= 0) {
            q.append(" and e.eventTypeId =").append(eventTypeId);
        }
        TypedQuery<EventDocumentType> query = entityManager.createQuery(q.toString(), EventDocumentType.class);
        return query.getResultList();
    }

}
