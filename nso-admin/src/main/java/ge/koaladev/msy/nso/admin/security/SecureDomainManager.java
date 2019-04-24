package ge.koaladev.msy.nso.admin.security;

/**
 * Created by mindia on 2/4/16.
 */
public class SecureDomainManager {

    private String secureDomain;
    private static final String ALLOW_ALL_DOMAIN = "0.0.0.0";

    public boolean isEnableAllDomain() {
        return ALLOW_ALL_DOMAIN.equals(secureDomain.trim());
    }

    public String getSecureDomain() {
        return secureDomain;
    }

    public void setSecureDomain(String secureDomain) {
        this.secureDomain = secureDomain;
    }
}
