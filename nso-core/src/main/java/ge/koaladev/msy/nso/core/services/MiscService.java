package ge.koaladev.msy.nso.core.services;

import ge.koaladev.msy.nso.core.dao.AnnualReportDao;
import ge.koaladev.msy.nso.core.dao.EventDocumentTypeDao;
import ge.koaladev.msy.nso.core.dao.EventTypeDao;
import ge.koaladev.msy.nso.core.dto.objects.*;
import ge.koaladev.msy.nso.database.model.AnnualReportDocumentType;
import ge.koaladev.msy.nso.database.model.CalendarType;
import ge.koaladev.msy.nso.database.model.Gender;
import ge.koaladev.msy.nso.database.model.PersonType;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author nino
 */
@Service
public class MiscService {

    @Autowired
    private EventTypeDao eventTypeDAO;
    @Autowired
    private EventDocumentTypeDao eventDocumentTypeDao;
    @Autowired
    private AnnualReportDao annualReportDao;


    @Transactional
    public List<PersonTypeDTO> getPersonTypes() {
        return PersonTypeDTO.parseToList(eventTypeDAO.getAll(PersonType.class));
    }

    @Transactional
    public List<GenderDTO> getGenders() {
        return GenderDTO.parseToList(eventTypeDAO.getAll(Gender.class));
    }

    @Transactional
    public List<EventTypeDTO> getEventTypes(int applicationTypeId) {
        return EventTypeDTO.parseToList(eventTypeDAO.getEventTypeByApplicationTypeId(applicationTypeId));
    }

    @Transactional
    public List<EventDocumentTypeDTO> getEventDocumentTypes(int eventTypeId) {
        return EventDocumentTypeDTO.parseToList(eventDocumentTypeDao.getEventDocumentTyoes(eventTypeId));
    }

    @Transactional
    public List<CalendarTypeDTO> getCalendarTypes() {
        return CalendarTypeDTO.parseToList(eventTypeDAO.getAll(CalendarType.class));
    }

    @Transactional
    public List<AnnualReportDocumentType> getAnnualReportDocumentTypes() {
        return annualReportDao.getAnnualReportDocumentTypes();
    }

}
