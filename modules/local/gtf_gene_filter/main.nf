process GTF_FILTER {
    tag "$fasta"

    conda "conda-forge::python=3.9.5"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/python:3.9--1' :
        'biocontainers/python:3.9--1' }"

    input:
    path fasta
    path gtf

    output:
    path "*_in_genome.gtf"           , emit: genome_gtf
    path "*_with_transcript_ids.gtf" , emit: transcript_id_gtf
    path "versions.yml"              , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script: // filter_gtf_for_genes_in_genome.py is bundled with the pipeline, in nf-core/rnaseq/bin/
    """
    filter_gtf.py \\
        --gtf $gtf \\
        --fasta $fasta \\
        --prefix ${fasta.baseName}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version | sed 's/Python //g')
    END_VERSIONS
    """
}
