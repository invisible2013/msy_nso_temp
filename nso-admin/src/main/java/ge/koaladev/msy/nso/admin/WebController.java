package ge.koaladev.msy.nso.admin;

import ge.koaladev.core.security.HasRight;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping
public class WebController {

    @RequestMapping("/")
    public String defaultPage() {
        return "old/login2";
    }

    @RequestMapping("/{page}")
    public String home(@PathVariable String page) {
        return page;
    }

    @RequestMapping({"/users"})
    @HasRight("admin")
    public String users() {
        return "old/users3";
    }

    @RequestMapping("/broadcastEmail")
    @HasRight(rights = {"admin", "top","chancellery"})
    public String broadcastEmail() {
        return "old/broadcastEmail2";
    }
}
