/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ge.koaladev.msy.nso.database.model;

import javax.persistence.*;
import javax.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;

/**
 *
 * @author nino
 */
@Entity
@Table(name = "annual_report_document")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "AnnualReportDocument.findAll", query = "SELECT e FROM AnnualReportDocument e")})
public class AnnualReportDocument implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @TableGenerator(name = "id_generator", table = "id_generator", valueColumnName = "value", pkColumnName = "pk_column_name", pkColumnValue = "annual_report_document_max_id", allocationSize = 1)
    @GeneratedValue(strategy = GenerationType.TABLE, generator = "id_generator")
    private Integer id;

    @Column(name = "annual_report_id")
    private Integer annualReportId;

    @JoinColumn(name = "type_id")
    @OneToOne
    private AnnualReportDocumentType type;

    @Column(name = "name")
    private String name;

    public AnnualReportDocument() {
    }

    public AnnualReportDocument(Integer id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getAnnualReportId() {
        return annualReportId;
    }

    public void setAnnualReportId(Integer annualReportId) {
        this.annualReportId = annualReportId;
    }

    public AnnualReportDocumentType getType() {
        return type;
    }

    public void setType(AnnualReportDocumentType type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof AnnualReportDocument)) {
            return false;
        }
        AnnualReportDocument other = (AnnualReportDocument) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "EventDocument[ id=" + id + " ]";
    }

}
