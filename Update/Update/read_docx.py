import sys
import docx

doc_path = r"d:\ESATECH_TEST\New AGV\Update\Update\Operating Documentation\Application Deployment Guide.docx"

try:
    doc = docx.Document(doc_path)
    text = []
    for para in doc.paragraphs:
        if para.text.strip():
            text.append(para.text.strip())
    
    print("\n".join(text))
except Exception as e:
    print("Error reading docx:", e)
