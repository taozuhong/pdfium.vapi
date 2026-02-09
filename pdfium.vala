using Gdk;
using Gtk;
using PDFium;

[GtkTemplate(ui = "/app/pdfium.ui")]
public class PdfiumWindow : Gtk.ApplicationWindow {
    [GtkChild]
    private unowned Gtk.MultiSelection selection;
    [GtkChild]
    private unowned Gtk.ListView view_pages;
    [GtkChild]
    private unowned GLib.ListStore model_pages;

    private uint8[] m_data;
    private PDFium.Document m_document;

    private int m_page_rotation = 0;
    private double m_scale_factor = 1.0;
    private bool m_fit_to_width = false;

    static construct {
        LibraryConfig config = LibraryConfig();
        config.version = 3;
        config.userFontPaths = null;
        config.isolate = null;
        config.v8EmbedderSlot = 0;
        config.platform = null;

        initLibraryWithConfig(&config);
    }

    public PdfiumWindow(Gtk.Application app) {
        Object (application: app);
    }

    public void load(uint8[] data)
    {
        m_data = data;
        if (0 == data.length) {
            model_pages.remove_all();
            return;
        }
        
        try {
            this.load_document(data);

            this.load_with_options(m_fit_to_width, m_scale_factor, m_page_rotation);
        } catch(Error err) {
            GLib.warning(err.message);
        }
    }

    [GtkCallback]
    private bool file_drop_handler(Value value, double x, double y)
    {
        Gdk.FileList file_list = (Gdk.FileList)value;
        var file_object = file_list.get_files().nth_data(0);
        string filename = file_object.get_path();
        if (!(file_object.query_exists() && file_object.is_native())) {
            GLib.warning("drop file is not exist: %s", filename);
            return false;
        }

        if (FileUtils.get_data(filename, out m_data)) {
            try {
                this.load_document(m_data);
                this.load_with_options(m_fit_to_width, m_scale_factor, m_page_rotation);
            } catch(Error err) {
                GLib.warning(err.message);
            }
        }

        return true;
    }

    [GtkCallback]
    private void button_fit_clicked_handler(Gtk.Button sender)
    {
        if (sender.name == "width") {
            sender.name = "page";
            sender.tooltip_text = "Fit to width";
            ((sender.child as Gtk.Box).get_first_child() as Gtk.Image).icon_name = "format-justify-fill-symbolic";
            ((sender.child as Gtk.Box).get_last_child() as Gtk.Label).label = "Fit to width";
            m_fit_to_width = false;
        } else {
            sender.name = "width";
            sender.tooltip_text = "Fit to page";
            ((sender.child as Gtk.Box).get_first_child() as Gtk.Image).icon_name = "format-justify-center-symbolic";
            ((sender.child as Gtk.Box).get_last_child() as Gtk.Label).label = "Fit to page";
            m_fit_to_width = true;
        }
        this.load_with_options(m_fit_to_width, m_scale_factor, m_page_rotation);
    }

    [GtkCallback]
    private void button_zoom_clicked_handler(Gtk.Button sender)
    {
        if (sender.name == "zoom-in") {
            m_scale_factor *= 1.25;
        } else { // zoom-out
            m_scale_factor = double.max(1.0, m_scale_factor / 1.25);
        }
        this.load_with_options(m_fit_to_width, m_scale_factor, m_page_rotation);
    }

    [GtkCallback]
    private void button_rotate_clicked_handler(Gtk.Button sender)
    {
        int rotation = int.parse(sender.name);
        rotation = ((rotation + 90) % 360);
        sender.name = "%d".printf(rotation);

        m_page_rotation = rotation / 90;
        this.load_with_options(m_fit_to_width, m_scale_factor, m_page_rotation);
    }

    [GtkCallback]
    private void button_open_clicked_handler(Gtk.Button sender)
    {
        var file_filters = new GLib.ListStore(typeof(Gtk.FileFilter));

        // PDF file filter
        var pdf_file_filter = new Gtk.FileFilter ();
        pdf_file_filter.set_filter_name("Portable document file");
        pdf_file_filter.add_pattern ("*.pdf");
        file_filters.append(pdf_file_filter);

        // All file filter
        var all_file_filter = new Gtk.FileFilter ();
        all_file_filter.set_filter_name ("All files");
        all_file_filter.add_pattern ("*.*");
        file_filters.append(all_file_filter);


        var file_dialog = new Gtk.FileDialog();
        file_dialog.title = "Open file";
        file_dialog.accept_label = "Open";
        file_dialog.filters = file_filters;
        file_dialog.default_filter = (FileFilter)file_filters.get_item(0);
        // file_dialog.set_do_overwrite_confirmation (true);
        // file_dialog.create_folders = true;
        // file_dialog.initial_folder = file_object;

        file_dialog.open.begin(this.root as Window, null, (obj, res) => {
            try {
                var file_object = file_dialog.open.end(res);
                if ((null != file_object) && FileUtils.get_data(file_object.get_path(), out m_data)) {
                    this.load_document(m_data);
                    this.load_with_options(m_fit_to_width, m_scale_factor, m_page_rotation);
                }
            } catch (DialogError.FAILED err) {
                GLib.error("Failed to open the file: %s", err.message);
            } catch(Error err) {
                GLib.warning("Failed to open the file: %s", err.message);
            }
        });
    }

    [GtkCallback]
    private void listview_setup_handler(Gtk.SignalListItemFactory factory, GLib.Object listitem)
    {
        var picture = new Gtk.Picture();
        picture.can_shrink = false;
        (listitem as Gtk.ListItem).child = picture;
    }

    [GtkCallback]
    private void listview_bind_handler(Gtk.SignalListItemFactory factory, GLib.Object listitem)
    {
        Gtk.Picture picture = (listitem as Gtk.ListItem).child as Gtk.Picture;
        picture.paintable = (listitem as Gtk.ListItem).item as Gdk.MemoryTexture;
    }

    private void load_document(uint8[] data) throws Error
    {
        m_document = new PDFium.Document.memory64(data, null);
        ulong err_code = PDFium.getLastError();
        if ((ErrorCode.SUCCESS != err_code) || (null == m_document)) {
            string message = "Unknown error";
            switch (err_code)
            {
            case ErrorCode.UNKNOWN:
                message = "Unknown error";
                break;
            case ErrorCode.FILE:
                message = "File not found or could not be opened";
                break;
            case ErrorCode.FORMAT:
                message = "File not in PDF format or corrupted";
                break;
            case ErrorCode.PASSWORD:
                message = "Password required or incorrect password";
                break;
            case ErrorCode.SECURITY:
                message = "Unsupported security scheme";
                break;
            case ErrorCode.PAGE:
                message = "Page not found or content error";
                break;
            default:
                message = "Unknown error";
                break;
            }

            model_pages.remove_all();
            throw new Error(Quark.from_string("PDF"), -1, message);
        }
    }

    private void load_with_options(bool fit_to_width = false, double scale = 1.0, int rotation = 0)
    {
        GLib.return_if_fail (null != m_document);

        GLib.Bytes bytes;
        PDFium.Page page;
        PDFium.Bitmap bitmap;
        uint8[] buffer = {};
        double height_for_fit_width;
        int pageWidth, pageHeight;
        int64 background = 0xFFFFFFFF;
        Gdk.MemoryTexture memory_texture;
        model_pages.remove_all();
        int page_count = m_document.getPageCount();
        RendererFlags renderer_flags = RendererFlags.REVERSE_BYTE_ORDER | RendererFlags.ANNOT | RendererFlags.LCD_TEXT;
        for (int i = 0; i < page_count; i++) {
            page = m_document.loadPage(i);
            pageWidth = fit_to_width ? view_pages.get_width() : (int)Math.lround(page.getPageWidth() * scale);
            height_for_fit_width = page.getPageHeight() * (view_pages.get_width() * 1.0 / page.getPageWidth());
            pageHeight = fit_to_width ? (int)Math.lround(height_for_fit_width) : (int)Math.lround(page.getPageHeight() * scale);
            buffer = new uint8[pageWidth * pageHeight * 4];
            bitmap = new PDFium.Bitmap.format(pageWidth, pageHeight, PDFium.BitmapFormat.BGRA, buffer, pageWidth * 4);

            bitmap.fillRect(0, 0, pageWidth, pageHeight, (ulong)background);
            bitmap.renderPageBitmap(page, 0, 0, pageWidth, pageHeight, rotation, renderer_flags);

            // Load bitmap into memory texture
            bytes = new Bytes(buffer);
            memory_texture = new MemoryTexture(pageWidth, pageHeight, MemoryFormat.R8G8B8A8, bytes, pageWidth * 4);

            model_pages.append(memory_texture);
        }
    }
}
