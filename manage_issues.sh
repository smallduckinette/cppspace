#!/bin/bash

# Script pour gérer les issues et les MR GitHub
# Utilise GitHub CLI (gh)

set -e

# Configuration
REPO="smallduckinette/cppspace"  # Remplace par ton nom d'utilisateur/repo
BRANCH_PREFIX="issue/"

# Vérifie si gh est installé
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) n'est pas installé. Veuillez l'installer d'abord."
    echo "Voir: https://cli.github.com/"
    exit 1
fi

# Vérifie si on est authentifié
if ! gh auth status &> /dev/null; then
    echo "Veuillez vous authentifier avec GitHub CLI:"
    gh auth login
fi

# Fonction pour traiter une issue
process_issue() {
    local issue_number=$1
    local issue_title=$2
    local issue_body=$3
    
    echo "\n=== Traitement de l'issue #$issue_number: $issue_title ==="
    
    # Vérifie si une MR existe déjà pour cette issue
    if gh pr list --head "${BRANCH_PREFIX}${issue_number}" --json number | grep -q "number"; then
        echo "Une MR existe déjà pour cette issue, en passant à la suivante."
        return
    fi
    
    # Crée une branche pour l'issue
    local branch_name="${BRANCH_PREFIX}${issue_number}"
    
    # Vérifie si on est sur la dernière version de main
    git checkout main
    git pull origin main
    
    # Crée la branche si elle n'existe pas, sinon va dessus
    if git show-ref --quiet refs/heads/"$branch_name"; then
        git checkout "$branch_name"
        git pull origin "$branch_name" 2>/dev/null || true
    else
        git checkout -b "$branch_name" main
    fi
    
    # Lance une session Vibe en mode headless pour implémenter la feature
    echo "Lancement de Vibe pour implémenter la feature..."
    echo "Description de l'issue:"
    echo "$issue_body"
    vibe --prompt "Implement the feature for issue #$issue_number: $issue_title. Description: $issue_body" --agent auto-approve --trust
    
    # Commit les changements faits par Vibe
    git add .
    git commit -m "Fix: $issue_title"
    
    # Pousse la branche et crée une MR
    git push origin "$branch_name"
    gh pr create --title "Fix: $issue_title" --body "Fix pour l'issue #$issue_number" --head "$branch_name" --base main
    
    # Retourne à la branche main
    git checkout main
}

# Fonction pour mettre à jour une MR en fonction des commentaires
update_pr() {
    local pr_number=$1
    local pr_title=$2
    
    echo "\n=== Mise à jour de la MR #$pr_number: $pr_title ==="
    
    # Récupère les commentaires
    local comments=$(gh pr view "$pr_number" --json comments --jq '.comments[] | .body')
    
    if [ -z "$comments" ]; then
        echo "Aucun commentaire trouvé."
        return
    fi
    
    echo "Commentaires trouvés:"
    echo "$comments"
    
    # Récupère la branche de la MR
    local head_branch=$(gh pr view "$pr_number" --json headRefName --jq '.headRefName')
    git checkout "$head_branch"
    
    # Lance une session Vibe pour traiter les commentaires
    echo "Lancement de Vibe pour traiter les commentaires..."
    echo "Commentaires:"
    echo "$comments"
    vibe --prompt "Address PR feedback for PR #$pr_number: $pr_title. Comments: $comments" --agent auto-approve --trust
    
    # Commit les changements faits par Vibe
    git add .
    git commit -m "Address PR feedback"
    
    # Pousse la mise à jour
    git push origin "$head_branch"
    
    # Répond aux commentaires
    gh pr comment "$pr_number" --body "J'ai adressé les commentaires et poussé une mise à jour."
    
    # Retourne à la branche main
    git checkout main
}

# Récupère la liste des issues ouvertes
echo "Récupération des issues ouvertes..."
issues=$(gh issue list --json number,title,body --jq '.[] | {number: .number, title: .title, body: .body}')

# Traite chaque issue
if [ -n "$issues" ]; then
    while read -r issue; do
        issue_number=$(echo "$issue" | jq -r '.number')
        issue_title=$(echo "$issue" | jq -r '.title')
        issue_body=$(echo "$issue" | jq -r '.body')
        
        process_issue "$issue_number" "$issue_title" "$issue_body"
    done <<< "$issues"
else
    echo "Aucune issue ouverte trouvée."
fi

# Récupère la liste des MR ouvertes
echo "\nRécupération des MR ouvertes..."
prs=$(gh pr list --json number,title --jq '.[] | {number: .number, title: .title}')

# Met à jour chaque MR
if [ -n "$prs" ]; then
    while read -r pr; do
        pr_number=$(echo "$pr" | jq -r '.number')
        pr_title=$(echo "$pr" | jq -r '.title')
        
        update_pr "$pr_number" "$pr_title"
    done <<< "$prs"
else
    echo "Aucune MR ouverte trouvée."
fi

echo "\n=== Traitement terminé ==="
