package ge.koaladev.msy.nso.core.dao;

import ge.koaladev.msy.nso.database.model.*;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import java.util.List;

/**
 * Created by NINO on 4/2/2018.
 */

@Repository
public class CompetitionDao extends AbstractDAO<Calendars> {

    @PersistenceContext(unitName = "nso")
    private EntityManager entityManager;

    @Override
    public EntityManager getEntityManager() {
        return entityManager;
    }

    @Transactional
    public List<Competition> getCompetition(Integer userId, String fullTextSearch, Integer limit, Integer offset, boolean isManager, Integer senderUserId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Competition.class.getSimpleName()).append(" e Where 1=1 ");
        if (fullTextSearch != null) {
            StringBuilder f = new StringBuilder();
            f.append(" and ( ");

            f.append("( e.name like '%" + fullTextSearch + "%' ) ");
            f.append("or ( e.senderUser.name like '%" + fullTextSearch + "%' ) ");

            f.append(" ) ");

            q.append(f.toString());
        }
        if (isManager) {
            q.append(" and e.senderUser.id = ").append(userId);
        }
        if (senderUserId != null) {
            q.append(" and e.federationUser.id = ").append(senderUserId);
        }
        q.append(" order by e.id desc ");
        TypedQuery<Competition> query = entityManager.createQuery(q.toString(), Competition.class);

        if (limit != null && offset != null) {
            query.setFirstResult(offset);
            query.setMaxResults(limit);
        }

        return query.getResultList();
    }


    public List<CompetitionPerson> getCompetitionPersons(Integer itemId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(CompetitionPerson.class.getSimpleName()).append(" e Where 1=1 ");
        q.append(" and e.competitionId = ").append(itemId);

        TypedQuery<CompetitionPerson> query = entityManager.createQuery(q.toString(), CompetitionPerson.class);
        return query.getResultList();
    }

    public List<CompetitionPerson> deleteCompetitionPersons(Integer itemId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(CompetitionPerson.class.getSimpleName()).append(" e Where 1=1 ");
        q.append(" and e.competitionId = ").append(itemId);

        TypedQuery<CompetitionPerson> query = entityManager.createQuery(q.toString(), CompetitionPerson.class);
        return query.getResultList();
    }

}
