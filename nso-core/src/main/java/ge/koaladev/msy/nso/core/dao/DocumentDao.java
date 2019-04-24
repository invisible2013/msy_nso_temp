package ge.koaladev.msy.nso.core.dao;

import ge.koaladev.msy.nso.core.dto.objects.DocumentDTO;
import ge.koaladev.msy.nso.core.dto.objects.MessageHistoryDTO;
import ge.koaladev.msy.nso.database.model.AbstractDAO;
import ge.koaladev.msy.nso.database.model.Document;
import ge.koaladev.msy.nso.database.model.Message;
import ge.koaladev.msy.nso.database.model.MessageHistory;
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
public class DocumentDao extends AbstractDAO<Message> {

    @PersistenceContext(unitName = "nso")
    private EntityManager entityManager;

    @Override
    public EntityManager getEntityManager() {
        return entityManager;
    }


    public List<DocumentDTO> getDocuments() {
        StringBuilder q = new StringBuilder();
        q.append("Select e From ").append(Document.class.getSimpleName()).append(" e ");

        TypedQuery<Document> query = entityManager.createQuery(q.toString(), Document.class);
        List<Document> result = query.getResultList();
        return result != null ? DocumentDTO.parseToList(result) : null;
    }
}
