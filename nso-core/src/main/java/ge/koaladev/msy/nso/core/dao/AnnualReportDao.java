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
public class AnnualReportDao extends AbstractDAO<Calendars> {

    @PersistenceContext(unitName = "nso")
    private EntityManager entityManager;

    @Override
    public EntityManager getEntityManager() {
        return entityManager;
    }

    @Transactional
    public List<AnnualReport> getAnnualReport(Integer userId, String fullTextSearch, Integer limit, Integer offset, boolean isFederation) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(AnnualReport.class.getSimpleName()).append(" e Where 1=1 ");
        if (fullTextSearch != null) {
            StringBuilder f = new StringBuilder();
            f.append(" and ( ");

            f.append("( e.introduction like '%" + fullTextSearch + "%' ) ");
            f.append("or ( e.result like '%" + fullTextSearch + "%' ) ");
            f.append("or ( e.conclusion like '%" + fullTextSearch + "%' ) ");
            f.append("or ( e.senderUser.name like '%" + fullTextSearch + "%' ) ");

            f.append(" ) ");

            q.append(f.toString());
        }
        if (isFederation) {
            q.append(" and e.senderUser.id = ").append(userId);
        }
        q.append(" order by e.id desc ");
        TypedQuery<AnnualReport> query = entityManager.createQuery(q.toString(), AnnualReport.class);

        if (limit != null && offset != null) {
            query.setFirstResult(offset);
            query.setMaxResults(limit);
        }

        return query.getResultList();
    }


    public List<AnnualReportDocument> getAnnualReportDocuments(Integer itemId) {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(AnnualReportDocument.class.getSimpleName()).append(" e Where 1=1 ");
        q.append(" and e.annualReportId = ").append(itemId);

        TypedQuery<AnnualReportDocument> query = entityManager.createQuery(q.toString(), AnnualReportDocument.class);
        return query.getResultList();
    }

    public List<AnnualReportDocumentType> getAnnualReportDocumentTypes() {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(AnnualReportDocumentType.class.getSimpleName()).append(" e Where 1=1 ");
        TypedQuery<AnnualReportDocumentType> query = entityManager.createQuery(q.toString(), AnnualReportDocumentType.class);
        return query.getResultList();
    }

}
