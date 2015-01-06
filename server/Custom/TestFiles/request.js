{
  "total": "50",
  success: true,
  "metaData": {
    supportsInsert: 1,
    supportsUpdate: 1,
    supportsDelete: 1
  },
  "data": [
    {
      "rowNumber": "1"/*,
      readOnly: true*/,
      "Id": "49",
      "Discapacidad": {
        value: '% de vista'
      },
      "IdCategoria": {
        value: {
          "id": '26',
          "text": 'Débil Visual'
        },
        children: [
          {
            id: '2',
            text: 'Física',
            fk: null, checked:false,
            children: [
              {
                id: '21',
                text: 'Acortamiento de extremidades',
                fk: "2",
                leaf: true, checked:false,
                iconCls: 'task'
              },
              {
                id: '22',
                text: 'Ausencia de alguna extremidad',
                fk: "2",
                children: [
                  {
                    id: '47',
                    text: 'Ausencia de pierna(s)',
                    fk: "22",
                    leaf: true,
                    iconCls: 'task'
                  },
                  {
                    id: '46',
                    text: 'Describa',
                    fk: "22",
                    leaf: true,
                    iconCls: 'task'
                  },
                  {
                    id: '48',
                    text: 'Hemiplejia de extremidades inferiores',
                    fk: "22",
                    leaf: true,
                    iconCls: 'task'
                  }
                ],
                expanded: true
              },
              {
                id: '23',
                text: 'De las extremidades superiores',
                fk: "2",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '15',
                text: 'Distrofía Muscular',
                fk: "2",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '19',
                text: 'Espina Bífida',
                fk: "2",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '18',
                text: 'Miembros afectados',
                fk: "2",
                children: [
                  {
                    id: '44',
                    text: '1 hemisferio',
                    fk: "18",
                    leaf: true,
                    iconCls: 'task'
                  },
                  {
                    id: '43',
                    text: '2 miembros inferiores',
                    fk: "18",
                    leaf: true,
                    iconCls: 'task'
                  },
                  {
                    id: '42',
                    text: '4 miembros',
                    fk: "18",
                    leaf: true,
                    iconCls: 'task'
                  },
                  {
                    id: '45',
                    text: 'Otro',
                    fk: "18",
                    leaf: true,
                    iconCls: 'task'
                  }
                ],
                expanded: true
              },
              {
                id: '24',
                text: 'Otra',
                fk: "2",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '16',
                text: 'Parálisis Cerebral',
                fk: "2",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '14',
                text: 'Persona pequeña',
                fk: "2",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '20',
                text: 'Pie equinovaro',
                fk: "2",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '17',
                text: 'Tono',
                fk: "2",
                children: [
                  {
                    id: '41',
                    text: 'Ataxia',
                    fk: "17",
                    leaf: true,
                    iconCls: 'task'
                  },
                  {
                    id: '40',
                    text: 'Atetósis',
                    fk: "17",
                    leaf: true,
                    iconCls: 'task'
                  },
                  {
                    id: '38',
                    text: 'Espasticidad',
                    fk: "17",
                    leaf: true,
                    iconCls: 'task'
                  },
                  {
                    id: '39',
                    text: 'Hipotonía',
                    fk: "17",
                    leaf: true,
                    iconCls: 'task'
                  }
                ],
                expanded: true
              }
            ],
            expanded: true
          },
          {
            id: '1',
            text: 'Intelectual',
            fk: null,
            children: [
              {
                id: '6',
                text: 'Leve',
                fk: "1",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '7',
                text: 'Moderada',
                fk: "1",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '13',
                text: 'Otra',
                fk: "1",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '8',
                text: 'Severa',
                fk: "1",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '9',
                text: 'Síndrome de Down',
                fk: "1",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '11',
                text: 'TDA – Trastorno por Déficit de atención',
                fk: "1",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '12',
                text: 'TDAH – Trastorno por Déficit de atención e Hiperactividad',
                fk: "1",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '10',
                text: 'Trastorno general del desarrollo',
                fk: "1",
                children: [
                  {
                    id: '37',
                    text: 'Asperger',
                    fk: "10",
                    leaf: true,
                    iconCls: 'task'
                  },
                  {
                    id: '36',
                    text: 'Autismo',
                    fk: "10",
                    leaf: true,
                    iconCls: 'task'
                  }
                ],
                expanded: true
              }
            ],
            expanded: true
          },
          {
            id: '4',
            text: 'Mental / Psicosocial',
            fk: null,
            children: [
              {
                id: '30',
                text: 'Alzheimer',
                fk: "4",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '32',
                text: 'Bipolaridad',
                fk: "4",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '33',
                text: 'Demencia Senil',
                fk: "4",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '29',
                text: 'Depresión',
                fk: "4",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '31',
                text: 'Esquizofrenia',
                fk: "4",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '35',
                text: 'Hidrocefalia',
                fk: "4",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '34',
                text: 'Pérdida de memoria',
                fk: "4",
                leaf: true,
                iconCls: 'task'
              }
            ],
            expanded: true
          },
          {
            id: '5',
            text: 'Otra',
            fk: null,
            leaf: true,
            iconCls: 'task'
          },
          {
            id: '3',
            text: 'Sensorial',
            fk: null,
            children: [
              {
                id: '25',
                text: 'Ciego',
                fk: "3",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '26',
                text: 'Débil Visual',
                fk: "3",
                children: [
                  {
                    id: '49',
                    text: '% de vista',
                    fk: "26",
                    leaf: true,
                    iconCls: 'task'
                  },
                  {
                    id: '50',
                    text: 'Comentarios',
                    fk: "26",
                    leaf: true,
                    iconCls: 'task'
                  }
                ],
                expanded: true
              },
              {
                id: '27',
                text: 'Mudo/Silente',
                fk: "3",
                leaf: true,
                iconCls: 'task'
              },
              {
                id: '28',
                text: 'Sordo',
                fk: "3",
                leaf: true,
                iconCls: 'task'
              }
            ],
            expanded: true
          }
        ]
      },
      "IdOtraCategoria": {
        value: {
          "id": '1',
          "text": 'Otra Categoria'
        },
        data: [
          {
            id: '1',
            text: 'Otra Categoria',
            fk: null,
            leaf: true,
            iconCls: 'task'
          }
        ]
      },
      "Discapacidades": {
        data: [
          {
            "rowNumber": "1"/*,
            readOnly: true*/,
            leaf: true,
            iconCls: 'task',
            expanded: true,
            checked: false,
            "Id": null,
            "PcD": {
              value: {
                "id": '2',
                "text": 'Anita'
              }
            },
            "Notas": {
              value: ''
            }
          }
        ]
      }
    }
  ]
}