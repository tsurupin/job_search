import styles from 'styled-components';
import colors from 'styles/colors';

export const Wrapper = styles.li`
  margin-top: 20px;
  padding-bottom: 20px;
  list-style: none;
  border-bottom: 1px solid ${colors.listBorderColor};
`;

export const Form = styles.form`
  width: 100%;
  display: flex;
  justify-content: center;
`;

export const Row = styles.div`
  width: ${props => props.size}0%;
` ;


export const UpdateButton = styles.button`
  color: ${props => props.disabled ? colors.leadSentenceColor : colors.primaryColor};
  cursor: ${props => props.disabled ? 'default' : 'pointer' };
  width: 56px;
  padding: 10px;
  &:hover {
    color: ${props => props.disabled ? colors.leadSentenceColor : colors.hoverPrimaryColor};;
  }
`;

export const CompanyWrapper = styles.div`
  display: flex;
  width: 100%;
 `;
export const CompanyInfo = styles.div`
  width: 78%;
`;

export const Title = styles.h3`
  font-size: 16px;
`;

export const Info = styles.p`
  font-size: 12px;
  margin-top: 5px;
  color: ${colors.leadSentenceColor};
`;

export const Icon = styles.span`
  width: 15%;
  margin-right: 7%;
  color: #009E5D;
  cursor: pointer;
`;
