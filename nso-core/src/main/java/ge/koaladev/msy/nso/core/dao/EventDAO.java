package ge.koaladev.msy.nso.core.dao;

import ge.koaladev.msy.nso.core.dto.objects.EventDTO;
import ge.koaladev.msy.nso.database.misc.ParamValuePair;
import ge.koaladev.msy.nso.database.model.AbstractDAO;
import ge.koaladev.msy.nso.database.model.Event;
import ge.koaladev.msy.nso.database.model.EventHistory;
import ge.koaladev.msy.nso.database.model.EventPerson;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TemporalType;
import javax.persistence.TypedQuery;
import java.util.*;

/**
 * @author mindia
 */
@Repository
public class EventDAO extends AbstractDAO<Event> {

    @PersistenceContext(unitName = "nso")
    private EntityManager entityManager;

    @Override
    public EntityManager getEntityManager() {
        return entityManager;
    }

    @Transactional
    public List<Event> getEventsByStatus(int statusId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Event.class.getSimpleName()).append(" e Where 1=1 ");
        if (statusId > 0) {
            q.append(" and e.lastStatus.id = ").append(statusId);
        }
        q.append(" order by e.id desc ");
        TypedQuery<Event> query = entityManager.createQuery(q.toString(), Event.class);
        return query.getResultList();
    }


    @Transactional
    public List<Event> getEventsByStatusAndDecision(int statusId, int decisionId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Event.class.getSimpleName()).append(" e Where 1=1 ");
        if (statusId > 0) {
            q.append(" and e.lastStatus.id = ").append(statusId);
        }
        if (decisionId > 0) {
            q.append(" and e.eventDecision.id = ").append(decisionId);
        }

        TypedQuery<Event> query = entityManager.createQuery(q.toString(), Event.class);
        return query.getResultList();
    }

    @Transactional
    public List<EventPerson> getEventPersonByPersonId(int personId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(EventPerson.class.getSimpleName()).append(" e Where 1=1 ");
        q.append(" and e.person.id = ").append(personId);

        TypedQuery<EventPerson> query = entityManager.createQuery(q.toString(), EventPerson.class);
        return query.getResultList();
    }

    @Transactional
    public List<Event> getEvents(Integer senderUserId, Integer supervisorId, Integer accountantId, Integer chancelleryId,
                                 Integer statusId, Date startDate, Date endDate, Integer limit, Integer offset, String fullTextSearch, boolean isAdmin,
                                 Date registeredDate,Integer federationId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Event.class.getSimpleName()).append(" e Where 1=1 ");

        Map<String, Object> params = new HashMap<>();

        if (isAdmin) {
            if (statusId != null) {
                q.append("and (e.lastStatus.id =").append(statusId)
                        .append(" or e.dispatcherId =").append(senderUserId)
                        .append(" or e.supervisorId =").append(senderUserId)
                        .append(") and e.lastStatus.id !=").append(EventDTO.EVENT_STATUS_CLOSED);
            } else {
                q.append("and (e.dispatcherId =").append(senderUserId)
                        .append(" or e.supervisorId =").append(senderUserId)
                        .append(" or e.lastStatus.id >").append(EventDTO.EVENT_STATUS_INCOMPLETE)
                        .append(") and e.lastStatus.id !=").append(EventDTO.EVENT_STATUS_CLOSED);

            }
        } else {
            if (senderUserId != null) {
                q.append(" and e.senderUser.id =").append(senderUserId);
            }
            if (supervisorId != null) {
                q.append(" and e.supervisorId =").append(supervisorId);
            }
            if (accountantId != null) {
                q.append(" and e.accountantId =").append(accountantId);
            }
            if (federationId != null) {
                q.append(" and e.senderUser.id =").append(federationId);
            }
            if (statusId != null) {
                if (chancelleryId != null) {
                    if (statusId != EventDTO.EVENT_STATUS_NEW) {
                        //History Chancellary
                        q.append("and e.lastStatus.id !=").append(EventDTO.EVENT_STATUS_NEW);
                        q.append("and e.lastStatus.id !=").append(EventDTO.EVENT_STATUS_ACCOUNTED);
                        q.append("and e.lastStatus.id !=").append(EventDTO.EVENT_STATUS_INCOMPLETE);
                    } else {
                        //New Chancellary
                        q.append(" and (e.lastStatus.id =").append(EventDTO.EVENT_STATUS_NEW);
                        q.append(" or e.lastStatus.id =").append(EventDTO.EVENT_STATUS_ACCOUNTED);
                        q.append(" or e.lastStatus.id =").append(EventDTO.EVENT_STATUS_APPROVED);
                        q.append(")");
                    }
                } else {
                    q.append(" and e.lastStatus.id =").append(statusId);
                }
            } else {
                q.append(" and e.lastStatus.id !=").append(EventDTO.EVENT_STATUS_CLOSED);
            }

        }

        if (fullTextSearch != null) {
            StringBuilder f = new StringBuilder();
            f.append(" and ( ");

            f.append("( e.eventName like '%" + fullTextSearch + "%' ) ");
            f.append("or ( e.lastStatus.name like '%" + fullTextSearch + "%' ) ");
            f.append("or ( e.eventDescription like '%" + fullTextSearch + "%' ) ");
            f.append("or ( e.registrationNumber like '%" + fullTextSearch + "%' ) ");
            f.append("or ( e.letterNumber like '%" + fullTextSearch + "%' ) ");
            f.append("or ( e.senderUser.name like '%" + fullTextSearch + "%' ) ");
            f.append("or ( e.responsiblePerson like '%" + fullTextSearch + "%' ) ");
            f.append("or ( e.responsiblePersonPosition like '%" + fullTextSearch + "%' ) ");

            f.append(" ) ");

            q.append(f.toString());
        }

        if (startDate != null) {
            q.append(" and e.createDate >=:startDate ");
            params.put("startDate", startDate);
        }
        if (endDate != null) {
            q.append(" and e.createDate <= :endDate");
            params.put("endDate", endDate);
        }

        if (registeredDate != null) {
            q.append(" and  e.id in (select h.event.id from ").append(EventHistory.class.getSimpleName())
                    .append(" h Where h.status.id=2 and h.createDate=:createDate ) ");
            params.put("createDate", registeredDate);
        }

        q.append(" order by e.id desc ");

        TypedQuery<Event> query = entityManager.createQuery(q.toString(), Event.class);

        if (limit != null && offset != null) {
            query.setFirstResult(offset);
            query.setMaxResults(limit);
        }

        for (Map.Entry<String, Object> entry : params.entrySet()) {
            if (entry.getValue() instanceof Date) {
                query.setParameter(entry.getKey(), (Date) entry.getValue(), TemporalType.TIMESTAMP);
            } else {
                query.setParameter(entry.getKey(), entry.getValue());
            }
        }

        List<Event> events = query.getResultList();

        return events;
    }


    @Transactional
    public List<Event> getEventsByUserId(int userId, int statusId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Event.class.getSimpleName()).append(" e Where e.senderUser.id =").append(userId);
        if (statusId > 0) {
            q.append(" and e.lastStatus.id =").append(statusId);
        } else {
            q.append(" and e.lastStatus.id !=").append(EventDTO.EVENT_STATUS_CLOSED);
        }
        q.append(" order by e.id desc ");
        TypedQuery<Event> query = entityManager.createQuery(q.toString(), Event.class);
        return query.getResultList();
    }

    @Transactional
    public List<Event> getBlockedEventsByUserId(int userId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Event.class.getSimpleName()).append(" e Where e.senderUser.id =").append(userId);
        q.append(" and ( e.lastStatus.id =").append(EventDTO.EVENT_STATUS_RETURNED);
        q.append(" or e.lastStatus.id =").append(EventDTO.EVENT_STATUS_CORRECTED).append(") ");
        TypedQuery<Event> query = entityManager.createQuery(q.toString(), Event.class);
        return query.getResultList();
    }

    @Transactional
    public List<Event> getReportEventsByUserId(int userId) {
        StringBuilder q = new StringBuilder();
        Map<String, Object> params = new HashMap<>();
        Date endDate = new Date();
        q.append("Select e From ").append(Event.class.getSimpleName()).append(" e Where e.senderUser.id =").append(userId);
        q.append(" and e.lastStatus.id =").append(EventDTO.EVENT_STATUS_REGISTERED);
        q.append(" and e.endDate+50 < :endDate ");
        params.put("endDate", endDate);

        TypedQuery<Event> query = entityManager.createQuery(q.toString(), Event.class);

        for (Map.Entry<String, Object> entry : params.entrySet()) {
            if (entry.getValue() instanceof Date) {
                query.setParameter(entry.getKey(), (Date) entry.getValue(), TemporalType.TIMESTAMP);
            } else {
                query.setParameter(entry.getKey(), entry.getValue());
            }
        }
        return query.getResultList();
    }

    @Transactional
    public Event checkReportEventById(int eventId) {
        StringBuilder q = new StringBuilder();
        Map<String, Object> params = new HashMap<>();
        Date endDate = new Date();
        q.append("Select e From ").append(Event.class.getSimpleName()).append(" e Where e.id =").append(eventId);
        q.append(" and e.endDate+50 < :endDate ");
        params.put("endDate", endDate);

        TypedQuery<Event> query = entityManager.createQuery(q.toString(), Event.class);

        for (Map.Entry<String, Object> entry : params.entrySet()) {
            if (entry.getValue() instanceof Date) {
                query.setParameter(entry.getKey(), (Date) entry.getValue(), TemporalType.TIMESTAMP);
            } else {
                query.setParameter(entry.getKey(), entry.getValue());
            }
        }
        return query.getResultList().size() == 0 ? null : query.getResultList().get(0);
    }


    @Transactional
    public List<Event> getEventsBySupervisorUserId(int userId, int statusId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Event.class.getSimpleName()).append(" e Where e.supervisorId =").append(userId);
        if (statusId > 0) {
            q.append(" and e.lastStatus.id =").append(statusId);
        } else {
            q.append(" and e.lastStatus.id !=").append(EventDTO.EVENT_STATUS_CLOSED);
        }
        q.append(" order by e.id desc ");
        TypedQuery<Event> query = entityManager.createQuery(q.toString(), Event.class);
        return query.getResultList();
    }

    @Transactional
    public List<Event> getEventsByAccountantUserId(int userId, int statusId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Event.class.getSimpleName()).append(" e Where e.accountantId =").append(userId);
        if (statusId > 0) {
            q.append(" and e.lastStatus.id =").append(statusId);
        } else {
            q.append(" and e.lastStatus.id !=").append(EventDTO.EVENT_STATUS_CLOSED);
        }
        q.append(" order by e.id desc ");
        TypedQuery<Event> query = entityManager.createQuery(q.toString(), Event.class);
        return query.getResultList();
    }

    @Transactional
    public List<Event> getEventByUserStatus(int userId, int statusId, Date startDate, Date endDate, Integer offset, Integer limit) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From Event e Where  (e.lastStatus.id =").append(statusId)
                .append(" or e.dispatcherId =").append(userId)
                .append(" or e.supervisorId =").append(userId)
                .append(") and e.lastStatus.id !=").append(EventDTO.EVENT_STATUS_CLOSED);
        if (startDate != null) {
            q.append(" and e.startDate >= " + startDate);
            //params.put("startDate", startDate);
        }
        if (endDate != null) {
            q.append(" and e.endDate <= :endDate");
            //params.put("endDate", endDate);
        }
        q.append(" order by e.id desc ");

        TypedQuery<Event> query = entityManager.createQuery(q.toString(), Event.class);
        if (offset != null && limit != null) {
            query.setFirstResult(offset);
            query.setMaxResults(limit);
        }
        return query.getResultList();
    }

    @Transactional
    public List<EventHistory> getEventHistory(int eventId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(EventHistory.class.getSimpleName()).append(" e Where e.event.id =").append(eventId);

        TypedQuery<EventHistory> query = entityManager.createQuery(q.toString(), EventHistory.class);
        List<EventHistory> results = query.getResultList();
        return query.getResultList();
    }

    @Transactional
    public Event getEventByKey(String key) {
        List<ParamValuePair> paramValuePairs = new ArrayList<>();
        ParamValuePair paramValuePair = new ParamValuePair("key", key);
        paramValuePairs.add(paramValuePair);
        List<Event> events = getAllByParamValue(Event.class, paramValuePairs);
        return events == null || events.size() == 0 ? null : events.get(0);
    }


}
