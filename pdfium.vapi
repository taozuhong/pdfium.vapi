/* 
  Copyright (C) 2026, Tao Zuhong

  Permission is hereby granted, free of charge, to any person obtaining a copy of
  this software and associated documentation files (the "Software"), to deal in
  the Software without restriction, including without limitation the rights to
  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
  of the Software, and to permit persons to whom the Software is furnished to do
  so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

  Reference: https://github.com/bblanchon/pdfium-binaries
*/

[CCode (cprefix = "FPDF_", cheader_filename = "fpdf_attachment.h,fpdf_thumbnail.h,fpdf_dataavail.h")]
namespace PDFium {
    [CCode (cname = "uint32_t", cprefix = "FPDF_OBJECT_", has_type_id = false)]
    public enum ObjectType {
        UNKNOWN,
        BOOLEAN,
        NUMBER,
        STRING,
        NAME,
        ARRAY,
        DICTIONARY,
        STREAM,
        NULLOBJ,
        REFERENCE
    }

    [CCode (cname = "uint32_t", cprefix = "FPDF_ERR_", has_type_id = false)]
    public enum ErrorCode {
        SUCCESS,
        UNKNOWN,
        FILE,
        FORMAT,
        PASSWORD,
        SECURITY,
        PAGE,
        XFALOAD,
        XFALAYOUT
    }

    [CCode (cname = "uint32_t", cprefix = "FPDFBitmap_", has_type_id = false)]
    public enum BitmapFormat {
        Unknown,
        Gray,
        BGR,
        BGRx,
        BGRA,
        BGRA_Premul
    }

    [CCode (cname = "uint32_t", cprefix = "FPDF_TEXTRENDERMODE_", has_type_id = false)]
    public enum RenderMode {
        UNKNOWN,
        FILL,
        STROKE,
        FILL_STROKE,
        INVISIBLE,
        FILL_CLIP,
        STROKE_CLIP,
        FILL_STROKE_CLIP,
        CLIP,
        LAST
    }

    [CCode (cname = "uint32_t", cprefix = "FPDF_", has_type_id = false)]
    public enum RendererFlags {
        ANNOT,
        LCD_TEXT,
        NO_NATIVETEXT,
        GRAYSCALE,
        DEBUG_INFO,
        NO_CATCH,
        RENDER_LIMITEDIMAGECACHE,
        RENDER_FORCEHALFTONE,
        PRINTING,
        RENDER_NO_SMOOTHTEXT,
        RENDER_NO_SMOOTHIMAGE,
        RENDER_NO_SMOOTHPATH,
        REVERSE_BYTE_ORDER,
        CONVERT_FILL_TO_STROKE
    }

    [CCode (cname = "uint32_t", cprefix = "FPDF_RENDERERTYPE_", has_type_id = false)]
    public enum RendererType {
        AGG,
        SKIA
    }

    [CCode (cname = "uint32_t", cprefix = "Duplex", has_type_id = false)]
    public enum DuplexType {
        Undefined,
        [CCode (cname = "Simplex")]
        Simplex,
        FlipShortEdge,
        FlipLongEdge
    }

    [CCode (cname = "int32_t", cprefix = "PDF_", has_type_id = false)]
    public enum AvailLinearFlags {
        LINEARIZATION_UNKNOWN,
        NOT_LINEARIZED,
        LINEARIZED
    }

    [CCode (cname = "int32_t", cprefix = "PDF_DATA_", has_type_id = false)]
    public enum AvailDataFlags {
        ERROR,
        NOTAVAIL,
        AVAIL
    }

    [CCode (cname = "int32_t", cprefix = "PDF_FORM_", has_type_id = false)]
    public enum AvailFormFlags {
        ERROR,
        NOTAVAIL,
        AVAIL,
        NOTEXIST
    }

    [CCode (cname = "FS_QUADPOINTSF", has_type_id = false)]
    public struct QuadPoints {
        public float x1;
        public float y1;
        public float x2;
        public float y2;
        public float x3;
        public float y3;
        public float x4;
        public float y4;
    }

    [CCode (cname = "FS_MATRIX", has_type_id = false)]
    public struct Matrix {
        public float a;
        public float b;
        public float c;
        public float d;
        public float e;
        public float f;
    }

    [CCode (cname = "FPDF_RECTF", has_type_id = false)]
    public struct Rectangle {
        public float left;
        public float top;
        public float right;
        public float bottom;
    }

    [CCode (cname = "FS_SIZEF", has_type_id = false)]
    public struct Size {
        public float width;
        public float height;
    }

    [CCode (cname = "FS_POINTF", has_type_id = false)]
    public struct Point {
        public float x;
        public float y;
    }

    [CCode (cname = "struct FPDF_LIBRARY_CONFIG_", has_type_id = false)]
    public struct LibraryConfig {
        public int version;
        [CCode (cname = "m_pUserFontPaths")]
        public string* userFontPaths;
        [CCode (cname = "m_pIsolate")]
        public void* isolate;
        [CCode (cname = "m_v8EmbedderSlot")]
        public uint32 v8EmbedderSlot;
        [CCode (cname = "m_pPlatform")]
        public void* platform;
        [CCode (cname = "m_RendererType")]
        public RendererType rendererType;
    }

    [CCode (cname = "FPDF_COLORSCHEME", has_type_id = false)]
    public struct ColorScheme {
        public ulong path_fill_color;
        public ulong path_stroke_color;
        public ulong text_fill_color;
        public ulong text_stroke_color;
    }

    [CCode (cname = "FPDF_BSTR", has_type_id = false)]
    public struct BSTR {
        [CCode (array_length_cname = "len")]
        public uint8[] str;
    }

    [CCode (cname = "struct fpdf_dest_t__", has_type_id = false, destroy_function = "")]
    public struct Dest {}

    [CCode (cname = "FPDF_InitLibraryWithConfig")]
    public void initLibraryWithConfig(LibraryConfig* config);

    [CCode (cname = "FPDF_InitLibrary")]
    public void initLibrary();

    [CCode (cname = "FPDF_DestroyLibrary")]
    public void destroyLibrary();

    [CCode (cname = "FPDF_SetSandBoxPolicy")]
    public void setSandBoxPolicy(ulong policy, int enable);

    [CCode (cname = "FPDF_SetPrintMode")]
    public int setPrintMode(int mode);

    [CCode (cname = "FPDF_LoadDocument")]
    public Document loadDocument(string file_path, string password);

    [CCode (cname = "FPDF_LoadMemDocument")]
    public Document loadMemDocument([CCode (array_length_type = "int")] uint8[] data_buf, string password);

    [CCode (cname = "FPDF_LoadMemDocument64")]
    public Document loadMemDocument64([CCode (array_length_type = "size_t")] uint8[] data_buf, string password);

    [CCode (cname = "FPDF_LoadCustomDocument")]
    public Document loadCustomDocument(ref FileAccess pFileAccess, string password);

    [CCode (cname = "FPDF_GetLastError")]
    public ulong getLastError();

    [Compact]
    [CCode (cname = "struct fpdf_document_t__", cprefix = "FPDF_", free_function = "FPDF_CloseDocument")]
    public class Document {
        [CCode (cname = "FPDF_LoadDocument")]
        public Document(string file_path, string? password);

        [CCode (cname = "FPDF_LoadMemDocument")]
        public Document.memory([CCode (array_length_type = "int")] uint8[] data_buf, string? password);

        [CCode (cname = "FPDF_LoadMemDocument64")]
        public Document.memory64([CCode (array_length_type = "size_t")] uint8[] data_buf, string? password);

        [CCode (cname = "FPDF_LoadCustomDocument")]
        public Document.custom(ref FileAccess pFileAccess, string? password);

        [CCode (cname = "FPDF_GetFileVersion")]
        public int getFileVersion(out int fileVersion);

        [CCode (cname = "FPDF_DocumentHasValidCrossReferenceTable")]
        public int hasValidCrossReferenceTable();

        [CCode (cname = "FPDF_GetTrailerEnds")]
        public ulong getTrailerEnds([CCode (array_length_type = "unsigned long")] uint[] buffer);

        [CCode (cname = "FPDF_GetDocPermissions")]
        public ulong getDocPermissions();

        [CCode (cname = "FPDF_GetDocUserPermissions")]
        public ulong getDocUserPermissions();

        [CCode (cname = "FPDF_GetSecurityHandlerRevision")]
        public int getSecurityHandlerRevision();

        [CCode (cname = "FPDF_GetPageCount")]
        public int getPageCount();

        [CCode (cname = "FPDFAvail_GetFirstPageNum")]
        public int getFirstPageNum();

        [CCode (cname = "FPDF_LoadPage")]
        public Page loadPage(int page_index);

        [CCode (cname = "FPDF_GetPageSizeByIndexF")]
        public int getPageSizeByIndexF(int page_index, out Size size);

        [CCode (cname = "FPDF_GetPageSizeByIndex")]
        public int getPageSizeByIndex(int page_index, out double width, out double height);

        [CCode (cname = "FPDF_VIEWERREF_GetPrintScaling")]
        public int getPrintScaling();

        [CCode (cname = "FPDF_VIEWERREF_GetNumCopies")]
        public int getNumCopies();

        [CCode (cname = "FPDF_VIEWERREF_GetPrintPageRange")]
        public PageRange getPrintPageRange();

        [CCode (cname = "FPDF_VIEWERREF_GetDuplex")]
        public DuplexType getDuplex();

        [CCode (cname = "FPDF_VIEWERREF_GetName")]
        public int getName(string key, [CCode (array_length_type = "unsigned long")]uint8[] buffer);

        [CCode (cname = "FPDF_CountNamedDests")]
        public ulong getNumNamedDests();

        [CCode (cname = "FPDF_GetNamedDestByName")]
        public Dest getNamedDestByName(string name);

        [CCode (cname = "FPDF_GetNamedDest")]
        public Dest getNamedDest(int index, [CCode (array_length_type = "long")] out uint8[] buffer);

        [CCode (cname = "FPDF_GetXFAPacketCount")]
        public int getXFAPacketCount();

        [CCode (cname = "FPDF_GetXFAPacketName")]
        public ulong getXFAPacketName(int index, [CCode (array_length_type = "unsigned long")] out uint8[] buffer);

        [CCode (cname = "FPDF_GetXFAPacketContent")]
        public int getXFAPacketContent(int index, [CCode (array_length_type = "unsigned long")] out uint8[] buffer, out ulong out_buflen);

        //////////////////////////////////////////////////////////////////
        // fpdf_attachment.h
        //////////////////////////////////////////////////////////////////
        [CCode (cname = "FPDFDoc_GetAttachmentCount")]
        public int getAttachmentCount();

        [CCode (cname = "FPDFDoc_GetAttachment")]
        public Attachment getAttachment(int index);
    }

    [Compact]
    [CCode (cname = "struct fpdf_page_t__", cprefix = "FPDF_", free_function = "FPDF_ClosePage")]
    public class Page {
        [CCode (cname = "FPDF_GetPageWidthF")]
        public float getPageWidthF();

        [CCode (cname = "FPDF_GetPageWidth")]
        public double getPageWidth();

        [CCode (cname = "FPDF_GetPageHeightF")]
        public float getPageHeightF();

        [CCode (cname = "FPDF_GetPageHeight")]
        public double getPageHeight();

        [CCode (cname = "FPDF_GetPageBoundingBox")]
        public int getPageBoundingBox(out Rectangle rect);

        [CCode (cname = "FPDF_DeviceToPage")]
        public int deviceToPage(int start_x, int start_y, int size_x, int size_y, int rotate, int device_x, int device_y, out double page_x, out double page_y);

        [CCode (cname = "FPDF_PageToDevice")]
        public int pageToDevice(int start_x, int start_y, int size_x, int size_y, int rotate, double page_x, double page_y, out int device_x, out int device_y);

        //////////////////////////////////////////////////////////////////
        // fpdf_thumbnail.h
        //////////////////////////////////////////////////////////////////

        [CCode (cname = "FPDFPage_GetDecodedThumbnailData")]
        public ulong getDecodedThumbnailData([CCode (array_length_type = "unsigned long")]uint8[] buffer);

        [CCode (cname = "FPDFPage_GetRawThumbnailData")]
        public ulong getRawThumbnailData([CCode (array_length_type = "unsigned long")]uint8[] buffer);

        [CCode (cname = "FPDFPage_GetThumbnailAsBitmap")]
        public Bitmap getThumbnailAsBitmap();
    }

    [Compact]
    [CCode (cname = "struct fpdf_bitmap_t__", cprefix = "FPDF_", free_function = "FPDFBitmap_Destroy")]
    public class Bitmap {
        [CCode (cname = "FPDFBitmap_Create")]
        public Bitmap(int width, int height, int alpha);

        [CCode (cname = "FPDFBitmap_CreateEx")]
        public Bitmap.format(int width, int height, BitmapFormat format, void* first_scan, int stride);

        [CCode (cname = "FPDF_RenderPageBitmap")]
        public void renderPageBitmap(Page page, int start_x, int start_y, int size_x, int size_y, int rotate, int flags);

        [CCode (cname = "FPDF_RenderPageBitmapWithMatrix")]
        public void renderPageBitmapWithMatrix(Page page, ref Matrix matrix, ref Rectangle clipping, int flags);

        [CCode (cname = "FPDFBitmap_GetFormat")]
        public BitmapFormat getFormat();

        [CCode (cname = "FPDFBitmap_FillRect")]
        public int fillRect(int left, int top, int width, int height, ulong color);

        [CCode (cname = "FPDFBitmap_GetBuffer")]
        public void* getBuffer();

        [CCode (cname = "FPDFBitmap_GetWidth")]
        public int getWidth();

        [CCode (cname = "FPDFBitmap_GetHeight")]
        public int getHeight();

        [CCode (cname = "FPDFBitmap_GetStride")]
        public int getStride();
    }

    [CCode (cname = "struct fpdf_pagerange_t__", has_type_id = false, destroy_function = "")]
    public struct PageRange {
        [CCode (cname = "FPDF_VIEWERREF_GetPrintPageRangeCount")]
        public size_t getPrintPageRangeCount();

        [CCode (cname = "FPDF_VIEWERREF_GetPrintPageRangeElement")]
        public int getPrintPageRangeElement();
    }

    [Compact]
    [CCode (cname = "struct fpdf_attachment_t__", cprefix = "FPDF_", free_function = "FPDFBitmap_Destroy")]
    public class Attachment {
        [CCode (cname = "FPDFAttachment_GetName")]
        public ulong getName([CCode (array_length_type = "unsigned long")]unichar2[] buffer);

        [CCode (cname = "FPDFAttachment_HasKey")]
        public int hasKey(string key);

        [CCode (cname = "FPDFAttachment_GetValueType")]
        public ObjectType getValueType(string key);

        [CCode (cname = "FPDFAttachment_GetStringValue")]
        public ulong getStringValue(string key, [CCode (array_length_type = "unsigned long")]unichar2[] buffer);

        [CCode (cname = "FPDFAttachment_GetFile")]
        public int getFile([CCode (array_length_type = "unsigned long")]uint8[] buffer, out ulong out_buflen);

        [CCode (cname = "FPDFAttachment_GetSubtype")]
        public ulong getSubtype([CCode (array_length_type = "unsigned long")]unichar2[] buffer);
    }

    [Compact]
    [CCode (cname = "struct fpdf_avail_t__", cprefix = "FPDFAvail_", free_function = "FPDFAvail_Destroy")]
    public class Availability {
        [CCode (cname = "FPDFAvail_Create")]
        public Availability(ref FileAvailability file_avail, ref FileAccess file_access);

        [CCode (cname = "FPDFAvail_IsDocAvail")]
        public int isDocAvail(ref DownloadHints hints);

        [CCode (cname = "FPDFAvail_GetDocument")]
        public Document getDocument(string password);

        [CCode (cname = "FPDFAvail_IsPageAvail")]
        public int isPageAvail(int page_index, ref DownloadHints hints);

        [CCode (cname = "FPDFAvail_IsFormAvail")]
        public int isFormAvail(ref DownloadHints hints);

        [CCode (cname = "FPDFAvail_IsLinearized")]
        public int isLinearized();
    }

    public delegate int GetBlock(void* param, ulong position, [CCode (array_length_type = "unsigned long")] uint8[] pBuf);
    public delegate void Release(void* clientData);
    public delegate ulong GetSize(void* clientData);
    public delegate ulong ReadBlock(void* clientData, ulong offset, [CCode (array_length_type = "unsigned long")] uint8[] buffer);
    public delegate ulong WriteBlock(void* clientData, ulong offset, [CCode (array_length_type = "unsigned long")] uint8[] buffer);
    public delegate int Flush(void* clientData);
    public delegate int Truncate(void* clientData, ulong size);
    public delegate int IsDataAvail(ref FileAvailability pThis, size_t offset, size_t size);
    public delegate int AddSegment(ref DownloadHints pThis, size_t offset, size_t size);

    [CCode (cname = "FPDF_FILEACCESS", has_type_id = false, destroy_function = "")]
    public struct FileAccess {

        [CCode (cname = "m_FileLen")]
        public ulong fileLen;

        [CCode (cname = "m_GetBlock")]
        public GetBlock getBlock;

        [CCode (cname = "m_Param")]
        public void* param;
    }

    [CCode (cname = "FPDF_FILEHANDLER", has_type_id = false, destroy_function = "")]
    public struct FileHandler {
        public void* clientData;

        [CCode (cname = "Release")]
        public Release release;
        [CCode (cname = "GetSize")]
        public GetSize getSize;
        [CCode (cname = "ReadBlock")]
        public ReadBlock readBlock;
        [CCode (cname = "WriteBlock")]
        public WriteBlock writeBlock;
        [CCode (cname = "Flush")]
        public Flush flush;
        [CCode (cname = "Truncate")]
        public Truncate truncate;
    }

    [CCode (cname = "FX_FILEAVAIL", has_type_id = false, destroy_function = "")]
    public struct FileAvailability {
        public int version;
        public IsDataAvail is_data_avail;
    }

    [CCode (cname = "FX_DOWNLOADHINTS", has_type_id = false, destroy_function = "")]
    public struct DownloadHints {
        public int version;
        public AddSegment add_segment;
    }
}