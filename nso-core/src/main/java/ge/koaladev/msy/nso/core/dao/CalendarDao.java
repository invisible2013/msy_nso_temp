package ge.koaladev.msy.nso.core.dao;

import ge.koaladev.msy.nso.core.dto.objects.MessageHistoryDTO;
import ge.koaladev.msy.nso.database.model.*;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.Calendar;
import java.util.List;

/**
 * Created by NINO on 4/2/2018.
 */

@Repository
public class CalendarDao extends AbstractDAO<Calendars> {

    @PersistenceContext(unitName = "nso")
    private EntityManager entityManager;

    @Override
    public EntityManager getEntityManager() {
        return entityManager;
    }

    @Transactional
    public List<Calendars> getCalendar(Integer userId, String fullTextSearch, Integer limit, Integer offset, boolean isFederation, Integer senderUserId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Calendars.class.getSimpleName()).append(" e Where 1=1 ");
        if (fullTextSearch != null) {
            StringBuilder f = new StringBuilder();
            f.append(" and ( ");

            f.append("( e.name like '%" + fullTextSearch + "%' ) ");
            f.append("or ( e.senderUser.name like '%" + fullTextSearch + "%' ) ");

            f.append(" ) ");

            q.append(f.toString());
        }
        if (isFederation) {
            q.append(" and e.senderUser.id = ").append(userId);
        }
        if (senderUserId != null && senderUserId != 0) {
            q.append(" and e.senderUser.id = ").append(senderUserId);
        }
        q.append(" order by e.id desc ");
        TypedQuery<Calendars> query = entityManager.createQuery(q.toString(), Calendars.class);

        if (limit != null && offset != null) {
            query.setFirstResult(offset);
            query.setMaxResults(limit);
        }
        return query.getResultList();
    }


    public List<CalendarPerson> getCalendarPersons(Integer calendarId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(CalendarPerson.class.getSimpleName()).append(" e Where 1=1 ");
        q.append(" and e.calendarId = ").append(calendarId);

        TypedQuery<CalendarPerson> query = entityManager.createQuery(q.toString(), CalendarPerson.class);
        return query.getResultList();
    }

}
