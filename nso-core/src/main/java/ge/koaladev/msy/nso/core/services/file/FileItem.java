package ge.koaladev.msy.nso.core.services.file;

/**
 * Created by mindia on 4/29/17.
 */
public class FileItem {

    private String name;
    private String thumbnail;

    public FileItem(String name, String thumbnail) {
        this.name = name;
        this.thumbnail = thumbnail;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }
}
