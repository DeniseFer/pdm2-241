from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database import engine, Base, get_db
from models import Aluno
from schemas import AlunoCreate, AlunoUpdate, AlunoInDB

app = FastAPI()

# Cria as tabelas no banco de dados
Base.metadata.create_all(bind=engine)

@app.post("/criar_aluno/", response_model=AlunoInDB)
def criar_aluno(aluno: AlunoCreate, db: Session = Depends(get_db)):
    db_aluno = Aluno(**aluno.dict())
    db.add(db_aluno)
    db.commit()
    db.refresh(db_aluno)
    return db_aluno

@app.get("/listar_alunos/", response_model=list[AlunoInDB])
def listar_alunos(db: Session = Depends(get_db)):
    return db.query(Aluno).all()

@app.get("/listar_um_aluno/{aluno_id}", response_model=AlunoInDB)
def listar_um_aluno(aluno_id: int, db: Session = Depends(get_db)):
    aluno = db.query(Aluno).filter(Aluno.id == aluno_id).first()
    if aluno is None:
        raise HTTPException(status_code=404, detail="Aluno não encontrado")
    return aluno

@app.put("/atualizar_aluno/{aluno_id}", response_model=AlunoInDB)
def atualizar_aluno(aluno_id: int, aluno: AlunoUpdate, db: Session = Depends(get_db)):
    db_aluno = db.query(Aluno).filter(Aluno.id == aluno_id).first()
    if db_aluno is None:
        raise HTTPException(status_code=404, detail="Aluno não encontrado")
    for key, value in aluno.dict().items():
        setattr(db_aluno, key, value)
    db.commit()
    db.refresh(db_aluno)
    return db_aluno

@app.delete("/excluir_aluno/{aluno_id}", response_model=AlunoInDB)
def excluir_aluno(aluno_id: int, db: Session = Depends(get_db)):
    db_aluno = db.query(Aluno).filter(Aluno.id == aluno_id).first()
    if db_aluno is None:
        raise HTTPException(status_code=404, detail="Aluno não encontrado")
    db.delete(db_aluno)
    db.commit()
    return db_aluno
