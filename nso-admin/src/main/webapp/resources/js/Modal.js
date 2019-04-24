var Modal = {
    modal: null,
    yesBtn: null,
    noBtn: null,
    body: null,
    onYes: null,
    onHide: null,

    init: function () {
        var me = this;

        this.yesBtn = $('<button>').attr({type: 'button'}).addClass('btn btn-primary').text('Yes');
        this.noBtn = $('<button>').attr({type: 'button'}).addClass('btn btn-default').attr('data-dismiss', 'modal').text('Close');
        this.body = $('<div>').addClass('modal-header').text('Are you sure?');

        this.modal = $('<div>').addClass('modal fade').css({zIndex: 1000000}).attr({
            role: 'dialog',
            'aria-hidden': 'true'
        }).append(
            $('<div>').addClass('modal-dialog').append(
                $('<div>').addClass('modal-content').append(
                    this.body
                ).append(
                    $('<div>').addClass('modal-footer').append(
                        this.noBtn
                    ).append(
                        this.yesBtn
                    )
                )
            )
        );

        this.yesBtn.click(function () {
            me.onYes && me.onYes("yes");
        });

        this.modal.on('hidden.bs.modal', function () {
            me.onHide && me.onHide();
        });

        $('body').append(this.modal);
    },

    show: function (cfg) {
        this.yesBtn.text(cfg.yes || 'Yes');
        this.noBtn.text(cfg.no || 'Close');
        this.body.text(cfg.body || 'Are you sure?');

        if (cfg.html) this.body.html(cfg.html);
        if (cfg.append) this.body.html('').append(cfg.append);

        this.yesBtn.css({display: cfg.without_yes ? 'none' : 'inline-block'})
        this.noBtn.css({display: cfg.without_no ? 'none' : 'inline-block'})

        this.onYes = cfg.callback || null;
        this.onHide = cfg.onHide || null;

        this.yesBtn.removeClass('btn-default btn-danger btn-info btn-primary btn-success btn-warning').addClass(cfg.yesClass || 'btn-primary')

        this.modal.modal('show');
    },

    hide: function () {
        this.modal.modal('hide');
    },

    info: function (text, callback) {
        var cfg = {};
        cfg.body = text;
        cfg.yesClass = "btn-primary";
        cfg.onHide = callback;
        cfg.without_yes = true;
        this.show(cfg);
    },
    confirm: function (bodyText, callback, btnText) {
        var cfg = {};
        cfg.body = bodyText;
        cfg.yesBtn = btnText;
        cfg.yesClass = "btn-primary";
        cfg.callback = callback;
        this.show(cfg);
    }
};

$(function () {
    Modal.init();
})