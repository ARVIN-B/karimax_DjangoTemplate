from openpyxl import Workbook
from openpyxl.styles import Font, Alignment, Border, Side, PatternFill
from openpyxl.utils import get_column_letter
from django.http import HttpResponse
import jdatetime
from datetime import datetime

def export_to_excel(columns, filename="گزارش.xlsx", report_title="گزارش سیستم"):

    if not columns:
        from django.http import HttpResponseBadRequest
        return HttpResponseBadRequest("داده‌ای برای اکسپورت وجود ندارد.")

    row_count = len(columns[0][1])
    for title, values in columns:
        if len(values) != row_count:
            raise ValueError("تعداد ردیف‌ها در همه ستون‌ها باید یکسان باشد.")

    wb = Workbook()
    ws = wb.active
    ws.title = "گزارش مشارکت‌ها"

    header_font = Font(name="B Nazanin", size=12, bold=True, color="FFFFFF")
    cell_font = Font(name="B Nazanin", size=11)
    center = Alignment(horizontal="center", vertical="center", wrap_text=True)
    right = Alignment(horizontal="right", vertical="center", wrap_text=True)
    border = Border(left=Side(style="thin"), right=Side(style="thin"), top=Side(style="thin"), bottom=Side(style="thin"))
    header_fill = PatternFill("solid", fgColor="1f4e79")

    row = 1

    # عنوان گزارش
    ws.cell(row=row, column=1, value=report_title).font = Font(name="B Nazanin", size=16, bold=True)
    ws.cell(row=row, column=1).alignment = center
    ws.merge_cells(start_row=row, start_column=1, end_row=row, end_column=len(columns))
    row += 2

    # تاریخ تولید
    jalali_date = jdatetime.datetime.now().strftime("%Y/%m/%d - %H:%M")
    ws.cell(row=row, column=1, value=f"تاریخ تولید گزارش: {jalali_date}").font = Font(name="B Nazanin", size=10, italic=True)
    ws.merge_cells(start_row=row, start_column=1, end_row=row, end_column=len(columns))
    row += 2

    # سرستون‌ها
    for col_num, (header_text, _) in enumerate(columns, 1):
        cell = ws.cell(row=row, column=col_num, value=header_text)
        cell.font = header_font
        cell.fill = header_fill
        cell.alignment = center
        cell.border = border
        ws.column_dimensions[get_column_letter(col_num)].width = 25

    row += 1

    # داده‌ها
    for i in range(row_count):
        for col_num, (_, values) in enumerate(columns, 1):
            value = values[i] if i < len(values) else ""
            if value is None:
                value = ""
            if isinstance(value, datetime):
                value = jdatetime.date.fromgregorian(date=value.date()).strftime("%Y/%m/%d")

            cell = ws.cell(row=row, column=col_num, value=str(value))
            cell.font = cell_font
            cell.border = border
            cell.alignment = center if "تاریخ" in columns[col_num-1][0] else right
        row += 1

    for r in range(1, row):
        ws.row_dimensions[r].height = 28

    response = HttpResponse(content_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    safe_filename = filename if filename.endswith(".xlsx") else f"{filename}.xlsx"
    response["Content-Disposition"] = f'attachment; filename="{safe_filename}"'
    wb.save(response)
    return response