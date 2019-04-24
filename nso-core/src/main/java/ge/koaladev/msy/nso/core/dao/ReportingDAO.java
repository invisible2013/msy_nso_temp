package ge.koaladev.msy.nso.core.dao;

import ge.koaladev.msy.nso.database.model.Event;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.TemporalType;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by mindia on 4/9/17.
 */
@Repository
public class ReportingDAO {

    @PersistenceContext(unitName = "nso")
    private EntityManager entityManager;


    public List<Event> report1(Integer federationId, List<Integer> eventTypes, Date startDate, Date endDate) {

        Map<String, Object> params = new HashMap<>();


        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Event.class.getSimpleName()).append(" e Where eventDecision.id = 1 ");
        q.append(" and e.senderUser.id = ").append(federationId);

        if (eventTypes != null && !eventTypes.isEmpty()) {
            q.append(" and e.eventType in(:types) ");
            params.put("types", eventTypes);
        }
        if (startDate != null) {
            q.append(" and e.createDate >=:startDate ");
            params.put("startDate", startDate);
        }
        if (endDate != null) {
            q.append(" and e.createDate <= :endDate");
            params.put("endDate", endDate);
        }

        Query query = entityManager.createQuery(q.toString());

        for (Map.Entry<String, Object> entry : params.entrySet()) {
            if (entry.getValue() instanceof Date) {
                query.setParameter(entry.getKey(), (Date) entry.getValue(), TemporalType.TIMESTAMP);
            } else {
                query.setParameter(entry.getKey(), entry.getValue());
            }
        }
        return query.getResultList();
    }
}
