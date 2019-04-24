package ge.koaladev.msy.nso.core.services;

import ge.koaladev.msy.nso.core.dao.ChampionshipDAO;
import ge.koaladev.msy.nso.core.dto.admin.AddChampionshipRequest;
import ge.koaladev.msy.nso.core.dto.objects.*;
import ge.koaladev.msy.nso.database.misc.ParamValuePair;
import ge.koaladev.msy.nso.database.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * Created by NINO on 4/18/2019.
 */
@Service
public class ChampionshipService {
    @Autowired
    private ChampionshipDAO championshipDAO;

    @Transactional
    public ChampionshipDTO saveResult(AddChampionshipRequest addRequest) {

        Championship request = new Championship();
        if (addRequest.getId() != 0) {
            request = championshipDAO.find(Championship.class, addRequest.getId());

        } else {
            request.setId(addRequest.getId());
        }
        request.setName(addRequest.getName());
        request.setDescription(addRequest.getDescription());
        request.setStartDate(addRequest.getStartDate());
        request.setEndDate(addRequest.getEndDate());
        request.setChampionshipTypeId(addRequest.getChampionshipTypeId());
        request.setChampionshipSubTypeId(addRequest.getChampionshipSubTypeId());
        request.setLocation(addRequest.getLocation());


        if (request.getId() == 0) {
            request.setCreateDate(new Date());
            request = championshipDAO.update(request);
        } else {
            request = championshipDAO.update(request);
        }

        return ChampionshipDTO.parse(request);
    }

    @Transactional
    public List<ChampionshipDTO> getChampionships(Integer start, Integer limit, String searchText) {
        HashMap<String, Object> resultMap = new HashMap();
        List<Championship> championships = championshipDAO.getChampionships(start, limit, searchText);
        List<ChampionshipDTO> items = ChampionshipDTO.parseToList(championships);
        return items;
    }

    @Transactional
    public void deleteChampionship(int itemId) {

        Championship championship = championshipDAO.find(Championship.class, itemId);
        if (championship != null) {
            championshipDAO.delete(championship);
        }
    }

    @Transactional
    public List<ChampionshipTypeDTO> getChampionshipTypes() {
        List<ChampionshipType> championships = championshipDAO.getAll(ChampionshipType.class);
        return ChampionshipTypeDTO.parseToList(championships);
    }

    @Transactional
    public List<ChampionshipSubTypeDTO> getChampionshipSubTypes(Integer championshipTypeId) {
        ParamValuePair paramValuePair = new ParamValuePair("championshipTypeId", championshipTypeId);
        List<ParamValuePair> list = new ArrayList<>();
        list.add(paramValuePair);
        List<ChampionshipSubType> championships = championshipDAO.getAllByParamValue(ChampionshipSubType.class, list);
        return ChampionshipSubTypeDTO.parseToList(championships);
    }


    @Transactional
    public List<AwardDTO> getAwards() {
        List<Award> awards = championshipDAO.getAll(Award.class);
        return AwardDTO.parseToList(awards);
    }
}
