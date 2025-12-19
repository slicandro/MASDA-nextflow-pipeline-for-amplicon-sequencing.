from Bio import SeqIO

def generate_gtf_contigs(fasta_file, output_gtf):
    """
    Genera un archivo GTF donde cada contig corresponde a un header del multifasta.
    
    Args:
        fasta_file (str): Ruta al archivo multifasta.
        output_gtf (str): Ruta al archivo de salida GTF.
    """
    with open(output_gtf, 'w') as gtf_out:
        for record in SeqIO.parse(fasta_file, "fasta"):
            contig_id = record.id
            seq_length = len(record.seq)
            
            # Crear una entrada GTF para el contig
            gtf_line = (
                f"{contig_id}\t"          # Nombre del contig (header)
                f"simulated\t"            # Fuente (simulada)
                f"contig\t"               # Tipo de característica
                f"1\t"                    # Inicio (siempre 1)
                f"{seq_length}\t"         # Fin (longitud de la secuencia)
                f".\t"                    # Score (sin valor, usamos '.')
                f"+\t"                    # Cadena (puedes modificar si lo necesitas)
                f".\t"                    # Fase (no aplica)
                f'gene_id "{contig_id}";\n'  # Atributos en formato GTF
            )
            gtf_out.write(gtf_line)
    print(f"Archivo GTF generado con los contigs en: {output_gtf}")

# Ejemplo de uso
fasta_file = "/mnt/Disk07/slicandro/ACAJOACO/Secuenciacion_Paneles/DAPPSeq_pipeline/references/ICUScan3.2_amplicon_sequences.fasta"  # Reemplaza con tu archivo multifasta
output_gtf = "/mnt/Disk07/slicandro/ACAJOACO/Secuenciacion_Paneles/DAPPSeq_pipeline/references/referencia_targets_ICUScan3.2.gtf"
generate_gtf_contigs(fasta_file, output_gtf)
