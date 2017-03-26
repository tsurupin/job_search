import styles from 'styled-components';
import colors from 'styles/colors';

export const Wrapper = styles.li`
  margin-top: 20px;
  padding-bottom: 20px;
  border-bottom: 1px solid ${colors.listBorderColor};
`;

export const Form = styles.form`
  width: 100%;
  display: flex;
`;

export const Row = styles.div`
  width: ${props => props.size}0%;
` ;