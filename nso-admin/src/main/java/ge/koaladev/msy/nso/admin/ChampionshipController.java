package ge.koaladev.msy.nso.admin;

import ge.koaladev.msy.nso.core.dto.admin.AddChampionshipRequest;
import ge.koaladev.msy.nso.core.misc.Response;
import ge.koaladev.msy.nso.core.services.ChampionshipService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by NINO on 4/18/2019.
 */
@Controller
@RequestMapping({"/championship"})
public class ChampionshipController {

    @Autowired
    private ChampionshipService championshipService;

    @ResponseBody
    @RequestMapping({"/save-championship"})
    public Response saveChampionship(@RequestBody AddChampionshipRequest request) {
        return Response.withSuccess(championshipService.saveResult(request));
    }

    @ResponseBody
    @RequestMapping({"/get-championships"})
    public Response getChampionships(@RequestParam int start, @RequestParam int limit, @RequestParam(required = false, defaultValue = "") String searchText) {
        return Response.withSuccess(championshipService.getChampionships(start, limit, searchText));
    }

    @ResponseBody
    @RequestMapping({"/delete-championship"})
    public Response deleteResult(@RequestParam int itemId) {
        this.championshipService.deleteChampionship(itemId);
        return Response.withSuccess(true);
    }

    @ResponseBody
    @RequestMapping({"/get-championship-types"})
    public Response getChampionshipTypes() {
        return Response.withSuccess(championshipService.getChampionshipTypes());
    }

    @ResponseBody
    @RequestMapping({"/get-championship-sub-types"})
    public Response getChampionshipSubTypes(@RequestParam int typeId) {
        return Response.withSuccess(championshipService.getChampionshipSubTypes(typeId));
    }

    @ResponseBody
    @RequestMapping({"/get-awards"})
    public Response getAwards() {
        return Response.withSuccess(championshipService.getAwards());
    }
}
