import os
import pandas as pd
from pathlib import Path

def convert_brainrot_files_to_excel():
    """
    brainrot_image 폴더에 있는 파일명들을 Excel 파일로 변환하는 함수
    """
    
    # brainrot_image 폴더 경로 설정
    folder_path = "brainrot_image"
    
    # 폴더가 존재하는지 확인
    if not os.path.exists(folder_path):
        print(f"오류: '{folder_path}' 폴더를 찾을 수 없습니다.")
        return
    
    # 파일명 리스트 생성
    file_names = []
    file_extensions = []
    file_names_without_ext = []
    
    try:
        # 폴더 내의 모든 파일 읽기
        for filename in os.listdir(folder_path):
            if os.path.isfile(os.path.join(folder_path, filename)):
                file_names.append(filename)
                
                # 파일 확장자 분리
                name_without_ext, extension = os.path.splitext(filename)
                file_names_without_ext.append(name_without_ext)
                file_extensions.append(extension)
        
        # 파일명 정렬 (한글 파일명 정렬)
        file_data = list(zip(file_names, file_names_without_ext, file_extensions))
        file_data.sort(key=lambda x: x[0])
        
        # 정렬된 데이터 분리
        file_names = [data[0] for data in file_data]
        file_names_without_ext = [data[1] for data in file_data]
        file_extensions = [data[2] for data in file_data]
        
        # DataFrame 생성
        df = pd.DataFrame({
            '번호': range(1, len(file_names) + 1),
            '전체 파일명': file_names,
            '파일명 (확장자 제외)': file_names_without_ext,
            '확장자': file_extensions
        })
        
        # Excel 파일로 저장
        output_filename = "brainrot_image_파일목록.xlsx"
        df.to_excel(output_filename, index=False, engine='openpyxl')
        
        print(f"✅ 성공적으로 Excel 파일을 생성했습니다: {output_filename}")
        print(f"📁 총 {len(file_names)}개의 파일이 목록에 포함되었습니다.")
        print("\n📋 파일 목록 미리보기:")
        print(df.head(10).to_string(index=False))
        
        if len(file_names) > 10:
            print(f"\n... 및 {len(file_names) - 10}개의 추가 파일들")
            
    except Exception as e:
        print(f"오류 발생: {str(e)}")

def main():
    """
    메인 함수
    """
    print("🎮 Brainrot Image 파일명 → Excel 변환기")
    print("=" * 50)
    
    convert_brainrot_files_to_excel()
    
    print("\n" + "=" * 50)
    print("✨ 변환 완료!")

if __name__ == "__main__":
    main() 