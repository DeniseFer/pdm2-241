from sqlalchemy import Column, Integer, String
from database import Base

class Aluno(Base):
    __tablename__ = "TB_ALUNO"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    aluno_nome = Column(String(50), index=True)
    endereco = Column(String(100))
