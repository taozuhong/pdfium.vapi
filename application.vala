public class PdfiumDemoApp : Gtk.Application {
    private PdfiumWindow window;
    
    public PdfiumDemoApp () {
        Object (application_id: "org.gnome.pdfium", flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate () {
        if (this.window == null) {
            this.window = new PdfiumWindow (this);
        }

        window.present();
    }
}

int main (string[] args) {
    var app = new PdfiumDemoApp ();
    return app.run (args);
}
